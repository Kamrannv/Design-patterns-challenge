//MARK: Without

struct VacationRequest {
  let days: Int
}

func handleVacationRequest(_ request: VacationRequest) {
  if request.days <= 2 {
    // Team Lead handling
    print("Team Lead: Approved \(request.days) day(s). ")
  }
  else if request.days <= 5 {
    // Manager handling
    print("Manager: Approved \(request.days) day(s). ")
  }
  else {
    // HR Director handling
    print("HR Director: Approved \(request.days) day(s). ")
  }
}

// Usage:
handleVacationRequest(VacationRequest(days: 1))
// → Team Lead: Approved 1 day(s). 

handleVacationRequest(VacationRequest(days: 4))
// → Manager: Approved 4 day(s). 

handleVacationRequest(VacationRequest(days: 10))
// → HR Director: Approved 10 day(s). 


//MARK: With
 
// 1) The request
struct VacationRequest {
  let days: Int
}

// 2) Handler protocol
protocol Approver: AnyObject {
  var nextApprover: Approver? { get set }
  func approve(_ request: VacationRequest)
}

extension Approver {
  // convenience to link the chain
  func setNext(_ next: Approver) {
    self.nextApprover = next
  }

  // convenience to forward if you can't handle
  func forward(_ request: VacationRequest) {
    nextApprover?.approve(request)
  }
}

// 3) Concrete handlers

class TeamLead: Approver {
  var nextApprover: Approver?
  func approve(_ request: VacationRequest) {
    if request.days <= 2 {
      print("Team Lead: Approved \(request.days) day(s). ")
    } else {
      print("Team Lead: Too many days, forwarding…")
      forward(request)
    }
  }
}

class Manager: Approver {
  var nextApprover: Approver?
  func approve(_ request: VacationRequest) {
    if request.days <= 5 {
      print("Manager: Approved \(request.days) day(s). ")
    } else {
      print("Manager: Too many days, forwarding…")
      forward(request)
    }
  }
}

class HRDirector: Approver {
  var nextApprover: Approver?
  func approve(_ request: VacationRequest) {
    // HR handles any length
    print("HR Director: Approved \(request.days) day(s). ")
  }
}


