## **Chain of Responsibility Pattern**

**#Behavioral**

### 1️⃣ The Scenario

1. **You want days off** and submit a vacation request for *N* days.
2. **Team Lead** can approve up to 2 days.
3. **Manager** can approve up to 5 days.
4. Anything above that goes to **HR Director**.

You don’t want “if days ≤2 do this, else if ≤5 do that, else do that” sprinkled all over your code. You just hand the request to the first person in the chain and let it flow until someone says “I can handle this.”

---

### 2️⃣ The Three Pieces

1. **Request** – carries the number of days.
2. **Handler** – the shared interface for everyone in the chain.
3. **Concrete Handlers** – TeamLead, Manager, HRDirector, each knows their limit and either approves or passes it on.

   WITHOUT Chain of Responsibility
   Here’s how you’d end up handling the same “vacation request” logic WITHOUT Chain of Responsibility—just a big if/else (or switch) all in one place:
   
   ```struct VacationRequest {
  let days: Int
}

func handleVacationRequest(_ request: VacationRequest) {
  if request.days <= 2 {
    // Team Lead handling
    print("Team Lead: Approved \(request.days) day(s). ✅")
  }
  else if request.days <= 5 {
    // Manager handling
    print("Manager: Approved \(request.days) day(s). ✅")
  }
  else {
    // HR Director handling
    print("HR Director: Approved \(request.days) day(s). ✅")
  }
}

// Usage:
handleVacationRequest(VacationRequest(days: 1))
// → Team Lead: Approved 1 day(s). ✅

handleVacationRequest(VacationRequest(days: 4))
// → Manager: Approved 4 day(s). ✅

handleVacationRequest(VacationRequest(days: 10))
// → HR Director: Approved 10 day(s). ✅```



### Why that’s less flexible

1. **All the choices live in one function.** If you need to change who approves 3–5 days, you edit that `else if` block directly.
2. **Harder to extend.** To add a “VP” who can approve up to 10 days, you’d have to insert another `else if` in the middle—risking off‑by‑one mistakes.
3. **Tight coupling.** Your client code must know about every approver and the whole chain of `if/else` logic, instead of just calling `first.approve(request)` and letting the chain handle itself.

WITH Chain of Responsibility

``` 
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
      print("Team Lead: Approved \(request.days) day(s). ✅")
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
      print("Manager: Approved \(request.days) day(s). ✅")
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
    print("HR Director: Approved \(request.days) day(s). ✅")
  }
}

```
