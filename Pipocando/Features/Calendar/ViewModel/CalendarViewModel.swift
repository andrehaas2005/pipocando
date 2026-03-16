//
//  CalendarViewModel.swift
//  AmorPorFilmesSeries
//

import Foundation

protocol CalendarRouting: AnyObject {
  func showSerieDetails(_ serie: Serie)
}

enum SerieState {
  case idle
  case loading
  case loaded([Serie])
  case error(AppError)
}

@MainActor
class CalendarViewModel {
  weak var coordinator: (any CalendarRouting)?

  // swiftlint:disable large_tuple
  var dates: Observable<[(day: String, date: String, fullDate: Date, isSelected: Bool)]> = Observable([])
  var releases: Observable<SerieState> = Observable(.idle)
  var selectedDateText: Observable<String?> = Observable(nil)
  var favoritesMap: Observable<[Int: Bool]> = Observable([:])

  private let serieService: any SerieServiceProtocol

  init(coordinator: any CalendarRouting, serieService: any SerieServiceProtocol) {
    self.coordinator = coordinator
    self.serieService = serieService
    fetchData()
  }

  func fetchData() {
    let generatedDates = generateWeekDates()
    dates.value = generatedDates

    if let selected = generatedDates.first(where: { $0.isSelected }) {
      selectedDateText.value = formatLongDate(selected.fullDate)
      fetchReleases(for: selected.fullDate)
    }
  }

  func didSelectDate(at index: Int) {
    guard var currentDates = dates.value, currentDates.indices.contains(index) else { return }

    for idx in currentDates.indices {
      currentDates[idx].isSelected = idx == index
    }

    dates.value = currentDates

    let selectedDate = currentDates[index].fullDate
    selectedDateText.value = formatLongDate(selectedDate)
    fetchReleases(for: selectedDate)
  }

  func didSelectSerie(at index: Int) {
    guard case let .loaded(series) = releases.value, series.indices.contains(index) else { return }
    coordinator?.showSerieDetails(series[index])
  }

  private func fetchReleases(for date: Date) {
    releases.value = .loading
    let apiDate = formatAPIDate(date)

    serieService.fetchSeriesAiring(on: apiDate) { [weak self] result in
      guard let self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let series):
          self.releases.value = .loaded(series)
          self.loadFavorites(for: series)
        case .failure(let error):
          self.releases.value = .error(AppError.map(error))
        }
      }
    }
  }

  private func loadFavorites(for series: [Serie]) {
    var map: [Int: Bool] = [:]
    let group = DispatchGroup()

    for serie in series {
      group.enter()
      MoviePreferenceStore.shared.fetch(movieID: serie.id, movieTitle: serie.name) { preference in
        map[serie.id] = preference.isFavorite
        group.leave()
      }
    }

    group.notify(queue: .main) { [weak self] in
      self?.favoritesMap.value = map
    }
  }

  func generateWeekDates() -> [(day: String, date: String, fullDate: Date, isSelected: Bool)] {

    let calendar = Calendar.current
    let today = Date()

    let dayFormatter = DateFormatter()
    dayFormatter.locale = Locale(identifier: "pt_BR")
    dayFormatter.dateFormat = "EEE"

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "pt_BR")
    dateFormatter.dateFormat = "dd"

    var result: [(day: String, date: String, fullDate: Date, isSelected: Bool)] = []

    for offset in -2...4 {

      if let date = calendar.date(byAdding: .day, value: offset, to: today) {

        let dayString = dayFormatter.string(from: date)
          .uppercased()

        let dateString = dateFormatter.string(from: date)

        let isSelected = calendar.isDate(date, inSameDayAs: today)

        result.append((day: dayString,
                       date: dateString,
                       fullDate: date,
                       isSelected: isSelected))
      }
    }
    return result
  }

  private func formatAPIDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }

  private func formatLongDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "pt_BR")
    formatter.dateFormat = "EEEE, d 'de' MMMM"
    return formatter.string(from: date).capitalized
  }
}
