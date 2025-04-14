struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount: Int
    public var currency: String
    
    private static let acceptedCurrencies = ["USD", "EUR", "GBP", "CAN"]
    
    public init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    private func toUSD() -> Double {
        if self.currency == "USD" {
            return Double(self.amount)
        }
        else if self.currency == "GBP" {
            return Double(self.amount) * 2.0
        }
        else if self.currency == "EUR" {
            return Double(self.amount) / 1.5
        }
        else if self.currency == "CAN" {
            return Double(self.amount) / 1.25
        }
        else {
            fatalError("Unsupported currency: \(self.currency)")
        }
    }
    
    private static func fromUSD(_ usd: Double, to currency: String) -> Int {
        if currency == "USD" {
            return Int((usd).rounded())
        }
        else if currency == "GBP" {
            return Int((usd / 2.0).rounded())
        }
        else if currency == "EUR" {
            return Int((usd * 1.5).rounded())
        }
        else if currency == "CAN" {
            return Int((usd * 1.25).rounded())
        }
        else {
            fatalError("Unsupported currency: \(currency)")
        }
    }
    
    public func convert(_ currency: String) -> Money {
        guard Self.acceptedCurrencies.contains(currency) else {
            fatalError("Unsupported currency: \(currency)")
        }
        let converted = Money.fromUSD(self.toUSD(), to: currency)
        return Money(amount: converted, currency: currency)
    }
    
    public func add(_ other: Money) -> Money {
        let selfUSD = self.toUSD()
        let otherUSD = other.toUSD()
        let sumUSD = selfUSD + otherUSD
        let totalAmount = Money.fromUSD(sumUSD, to: other.currency)
        return Money(amount: totalAmount, currency: other.currency)
    }
    
    public func subtract (_ other: Money) -> Money {
        let selfUSD = self.toUSD()
        let otherUSD = other.toUSD()
        let differenceUSD = selfUSD - otherUSD
        let totalAmount = Money.fromUSD(differenceUSD, to: self.currency)
        return Money(amount: totalAmount, currency: self.currency)
    }
    
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    public var title: String
    public var type: JobType
    
    public init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public func calculateIncome(_ hours: Int) -> Int {
        if case .Hourly(let rate) = type {
            return Int(rate * Double(hours))
        }
        else if case .Salary(let annual) = type {
            return Int(annual)
        }
        else {
            return 0
        }
    }
    
    public func raise(byAmount amount: Double) {
        if case .Hourly(let rate) = type {
            type = .Hourly(rate + amount)
        }
        else if case .Salary(let yearly) = type {
            type = .Salary(yearly + UInt(amount))
        }
    }
    
    public func raise(byPercent percent: Double) {
        if case .Hourly(let income) = type {
            type = .Hourly(income * (1 + percent))
        }
        else if case .Salary(let income) = type {
            let newIncome = Double(income) * (1 + percent)
            type = .Salary(UInt(newIncome))
        }
    }
    
    
    
    
}

////////////////////////////////////
// Person
//
public class Person {
}

////////////////////////////////////
// Family
//
public class Family {
}
