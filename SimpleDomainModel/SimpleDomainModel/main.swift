//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible {
  
  public var description: String {
    return "\(self.currency) \(self.amount)"
  }
  
  public var amount : Int
  public var currency : String
  
  public func convert(_ to: String) -> Money {
    var usdConversion = convertToUsd(amount: amount, currency: currency)
    switch to {
      case "GBP":
        usdConversion = usdConversion / 2
      case "EUR":
        usdConversion = usdConversion * 3 / 2
      case "CAN":
        usdConversion = usdConversion * 5 / 4
      default:
       break
    }
    return Money(amount: usdConversion, currency: to)
  }
  
  private func convertToUsd(amount: Int, currency: String) -> Int {
    switch currency {
      case "GBP":
        return amount * 2
      case "EUR":
        return amount * 2 / 3
      case "CAN":
        return amount * 4 / 5
      default:
        return amount
    }
  }
  
  public func add(_ to: Money) -> Money {
    if to.currency == self.currency {
      return Money(amount: self.amount + to.amount, currency: to.currency)
    }
    let newMoneyConversion = self.convert(to.currency)
    return Money(amount: to.amount + newMoneyConversion.amount, currency: to.currency)
  }
  
  public func subtract(_ from: Money) -> Money {
    if from.currency == self.currency {
      return Money(amount: self.amount - from.amount, currency: from.currency)
    }
    return Money(amount: self.amount - self.convert(from.currency).amount, currency: from.currency)
  }
}

protocol Mathematics {
  func add(_ to: Money) -> Money
  
  func subtract(_ to: Money) -> Money
}

////////////////////////////////////
// Job
//
open class Job: CustomStringConvertible{
  
  public var description: String {
    return "\(self.title) \(self.calculateIncome(1))"
  }
  
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch type {
    case .Hourly(let rate):
      return Int(rate * Double(hours))
    case .Salary(let rate):
      return rate
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
    case .Hourly(let rate):
      self.type = .Hourly(rate + amt)
    case .Salary(let rate):
      self.type = .Salary(rate + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person: CustomStringConvertible {
  public var description: String {
    return "\(self.firstName) \(self.lastName) \(self.age)"
  }
  
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get { return _job }
    set(value) {
      if age >= 16 {
        _job = value
      }
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get { return _spouse }
    set(value) {
      if age >= 18 {
        _spouse = value
      }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
  }
}

////////////////////////////////////
// Family
//
open class Family: CustomStringConvertible{
  
  public var description: String {
    return "\(members.count) family members"
  }
  
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if spouse1.spouse == nil && spouse2.spouse == nil {
      spouse1.spouse = spouse2
      spouse2.spouse = spouse1
      members.append(spouse1)
      members.append(spouse2)
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    for person in members {
      if person.age >= 21 {
        members.append(child)
        return true
      }
    }
    return false
  }
  
  open func householdIncome() -> Int {
    var totalIncome = 0
    for person in members {
      if person.job != nil {
        totalIncome += (person.job!.calculateIncome(2000))
      }
    }
    return totalIncome
  }
}
