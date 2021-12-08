import UIKit

var greeting = "Hello, playground"

protocol Banking {
    func withDrawAmount(amount: Double) throws
}

enum WithdrawalError: Error {
    case insufficientAccountBalance
}

var accountBalance: Double = 30000.0

struct Atm: Banking {
    func withDrawAmount(amount: Double) throws {
        debugPrint("inside atm")
        guard accountBalance > amount else { throw
            WithdrawalError.insufficientAccountBalance
        }
        Thread.sleep(forTimeInterval: Double.random(in: 1...3))
        accountBalance -= amount
    }
    func printMessage() {
        debugPrint("ATM withdrawal successful, new account balance = \(accountBalance) ")
    }
}

struct Bank: Banking {
    func withDrawAmount(amount: Double) throws {
        debugPrint("inside bank")
        guard accountBalance > amount else { throw
            WithdrawalError.insufficientAccountBalance
        }
        Thread.sleep(forTimeInterval: Double.random(in: 1...3))
        accountBalance -= amount
    }
    func printMessage() {
        debugPrint("Bank withdrawal successful, new account balance = \(accountBalance) ")
    }
}

let queue = DispatchQueue(label: "SemaphoneDemo", qos: .utility, attributes: .concurrent)

let semaphore = DispatchSemaphore(value: 1)

queue.async {
    //Money withdrawal from ATM
    do {
        semaphore.wait()
        let atm = Atm()
        try atm.withDrawAmount(amount: 25000)
        atm.printMessage()
        semaphore.signal()
    } catch WithdrawalError.insufficientAccountBalance {
        semaphore.signal()
        debugPrint("ATM withdrawal failure: The account balance is less then the amount you want to withdraw, transaction cancelled")
    }
    catch {
        semaphore.signal()
        debugPrint("Error")
    }
}


queue.async {
    //Money withdrawal from Bank
    do {
        semaphore.wait()
        let bank = Bank()
        try bank.withDrawAmount(amount: 10000)
        bank.printMessage()
        semaphore.signal()
    } catch WithdrawalError.insufficientAccountBalance {
        semaphore.signal()
        debugPrint("Bank withdrawal failure: The account balance is less then the amount you want to withdraw, transaction cancelled")
    }
    catch {
        semaphore.signal()
        debugPrint("Error")
    }
}


