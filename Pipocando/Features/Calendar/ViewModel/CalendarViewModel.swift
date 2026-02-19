//
//  CalendarViewModel.swift
//  AmorPorFilmesSeries
//

import Foundation

enum SerieState {
  case loading(Bool)
  case success([Serie])
  case failure(String)
}

class CalendarViewModel {
  weak var coordinator: CalendarCoordinator?
  
  // swiftlint:disable large_tuple
  var dates: Observable<[(day: String, date: String, isSelected: Bool)]> = Observable([])
  var releases: Observable<SerieState> = Observable(.loading(false))
  var service: SerieService
  
  init(coordinator: CalendarCoordinator, service: SerieService = .shared) {
    self.coordinator = coordinator
    self.service = service
    fetchData()
  }
  
  func fetchData() {
    dates.value = generateWeekDates()
    service.fetchSerieTopReted { [weak self] result in
      switch result {
      case .success(let series):
        self?.releases.value = .success(series)
      case .failure(let error):
        self?.releases.value = .failure(error.localizedDescription)
      }
    }
  }
  
  func generateWeekDates() -> [(day: String, date: String, isSelected: Bool)] {
    
    let calendar = Calendar.current
    let today = Date()
    
    // Formatter para dia da semana (SEG, TER...)
    let dayFormatter = DateFormatter()
    dayFormatter.locale = Locale(identifier: "pt_BR")
    dayFormatter.dateFormat = "EEE"
    
    // Formatter para dia numérico (18, 19...)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "pt_BR")
    dateFormatter.dateFormat = "dd"
    
    var result: [(day: String, date: String, isSelected: Bool)] = []
    
    for offset in -2...4 { // 2 dias antes + hoje + 4 depois = 7 dias
      
      if let date = calendar.date(byAdding: .day, value: offset, to: today) {
        
        let dayString = dayFormatter.string(from: date)
          .uppercased()
        
        let dateString = dateFormatter.string(from: date)
        
        let isSelected = calendar.isDate(date, inSameDayAs: today)
        
        result.append((day: dayString,
                       date: dateString,
                       isSelected: isSelected))
      }
    }
    return result
  }
}
