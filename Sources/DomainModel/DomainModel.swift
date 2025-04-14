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
    
    // initialize
    public init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    // from diff currency to USD
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
    
    // from USD to diff currency
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
    
    // convert to USD and then to target currency
    public func convert(_ currency: String) -> Money {
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
    
    // initialize title and type
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
    public var firstName: String
    public var lastName: String
    public var age: Int
    
    private var _job: Job?
    private var _spouse: Person?
    
    // only > 15 can get a job
    var job: Job? {
        get {return _job}
        set {
            if age >= 16 {
                _job = newValue
            } else {
                _job = nil
            }
        }
    }
   
    // only > 18 can have a spouse
    var spouse:Person? {
        get {return _spouse}
        set {
            if age >= 18 {
                _spouse = newValue
            } else {
                _spouse = nil
            }
        }
    }
    
    public init(firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    // toString description of a person
    public func toString() -> String {
        var jobDesc: String
        if job != nil {
            jobDesc = "\(job!.type)"
        }
        else {
            jobDesc = "nil"
        }
        
        var spouseDesc: String
        if spouse != nil {
            spouseDesc = "\(spouse!.firstName) \(spouse!.lastName)"
        }
        else {
            spouseDesc = "nil"
        }
        
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobDesc) spouse:\(spouseDesc)]"
    }
    
}

////////////////////////////////////
// Family
//
public class Family {
    public var members: [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        // assign spouses to each other if not already married
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
    
    public func haveChild(_ child: Person) -> Bool {
        // need 2+ people to be a family
        if members.count < 2 {
           return false
        }
        // at least 1 member must be 21+
        if members[0].age >= 21 || members[1].age >= 21 {
            self.members.append(child)
            return true
        }
        return false
    }
    
    public func householdIncome() -> Int {
        var totalIncome: Int = 0
        for member in members {
            if let job = member.job {
                totalIncome += job.calculateIncome(2000)
            }
        }
        return totalIncome
    }
            
}
