//
//  HomeViewControllerDelegate.swift
//  Pipocando
//
//  Created by Andre  Haas on 20/02/26.
//


protocol HomeViewControllerDelegate: AnyObject {
    func didSelectMovie(_ movie: Movie)
    func didRequestLogout()
}