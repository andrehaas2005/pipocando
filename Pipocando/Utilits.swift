//
//  Utilits.swift
//  Pipocando
//
//  Created by Andre  Haas on 12/02/26.
//


import Foundation
import UIKit

final public class Utilits {
  
  public static func createSectionStack(label: UILabel, content: UIView, rightMargein: CGFloat = 0, leftMargein: CGFloat = 0, topMargein: CGFloat = 0, bottonMargein: CGFloat = 0,  spacing: CGFloat = 8) -> UIStackView {
      let stack = UIStackView(arrangedSubviews: [label, content])
      stack.axis = .vertical
      stack.spacing = spacing
      stack.isLayoutMarginsRelativeArrangement = true
      stack.layoutMargins = UIEdgeInsets(top: topMargein, left: leftMargein, bottom: bottonMargein, right: rightMargein)
      if content is UICollectionView {
          stack.layoutMargins = UIEdgeInsets(top: topMargein, left: leftMargein, bottom: bottonMargein, right: rightMargein)
      }
      return stack
  }
  
  public static func createSectionLabel(_ title: String) -> UILabel {
      let label = UILabel()
      label.text = title
      label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
      label.textColor = .white.withAlphaComponent(0.9)
      let attributedString = NSMutableAttributedString(string: title)
      attributedString.addAttribute(.kern, value: 1.5, range: NSRange(location: 0, length: title.count))
      label.attributedText = attributedString
      return label
  }
    // Função para carregar o arquivo JSON e popular a classe Codable
    private static func carregarJson<T: Decodable>(_ meuArquivo: String) -> T? {
        // Localize o arquivo JSON no projeto
        guard let url = Bundle.main.url(forResource: meuArquivo, withExtension: "json") else {
            return nil
        }
        
        do {
            // Carregue o conteúdo do arquivo JSON
            let data = try Data(contentsOf: url)
            
            // Decodifique o JSON em uma lista de objetos
            let objetos = try JSONDecoder().decode(T.self, from: data)
            
            return objetos
        } catch {
            print("Erro ao carregar o arquivo JSON: \(error)")
            return nil
        }
    }
    
    static public func getObject<T: Decodable>(_ nomeJson: String) -> [T] {
        guard let cover: Cover<T> = Self.carregarJson(nomeJson) else {
            return []
        }
        return cover.results
    }
}

