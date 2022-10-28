# EditValueView

Library that makes easy to display property edit screens for SwiftUI.

## Demo

|  String  |  Bool  |  Int  |
| ---- | ---- | ---- |
|  ![String-light](https://user-images.githubusercontent.com/50244599/197402681-7e3c4ec8-f7c3-4ad7-9e31-8e3cd270342f.png)  |  ![Bool-light](https://user-images.githubusercontent.com/50244599/197402668-973d18c4-9f87-4f2f-9e6c-77072b4a8db6.png)  |  ![Int-light](https://user-images.githubusercontent.com/50244599/197402680-eb91f16f-52db-441a-b923-706889c256f8.png)  |

|  Double  |  Date  |  Color  |
| ---- | ---- | ---- |
|  ![Double-light](https://user-images.githubusercontent.com/50244599/197402677-cb2a90ca-58fa-4d2d-8459-fa2539836c36.png) |  ![Date-light](https://user-images.githubusercontent.com/50244599/197402673-414f5b2d-9031-4ad3-81de-300d85e5ad56.png)  |  ![Color-light](https://user-images.githubusercontent.com/50244599/197402671-8a224878-ab39-4471-b072-cbb19a2d38b9.png)  |

|  Array  |  Dictionary  |
| ---- | ---- |
|  ![Array-light](https://user-images.githubusercontent.com/50244599/197402664-fce3326c-824d-4853-9a5b-47903ccdf470.png)  |  ![Dictionary-light](https://user-images.githubusercontent.com/50244599/197402675-d1dd4bdb-6135-4c45-89f9-2f640daf9f3d.png)  |

|  Enum(CaseIterable)  |  Enum(CaseIterable & RawRepresentable)  |
| ---- | ---- |
|  ![Enum(CaseIterable)-light](https://user-images.githubusercontent.com/50244599/197402679-c6be841f-02ca-4db6-81ba-5e5e4893058d.png)  |  ![Enum(CaseIterable   RawRepresentable)-light](https://user-images.githubusercontent.com/50244599/197402678-dc8547ec-add7-436c-8cba-44d950f0d676.png)  | 

|  Codable  |
|  ----  |
|  ![Codable-light](https://user-images.githubusercontent.com/50244599/197402669-5fe684df-cbbe-4945-b89e-264e00fed733.png)  |


## Usage
### SwiftUI
```swift
EditValueView(target, key: "name", keyPath: \Item.name)
    .onUpdate { target, newValue in
        // update
    }
    .validate { target, newValue -> Bool in
        // input validation
    } 
```

### UIKit
```swift
let vc = EditValueViewController(target, key: "name", keyPath: \Item.name)
vc.onUpdate = { target, newValue in
    // update
}
vc.validate = { target, newValue -> Bool in
    // input validation
}
```

### Protocol
If you use a keypath of an optional type, either define a default value according to the `DefaultRepresentable` protocol or give the default value in the initilalize

```swift
struct Item: Codable {
    var name: String
    var date: Date
}

struct Message: Codable {
    var content: String
    var item: Item?
}
```
```swift
// Confirm to `DefaultRepresentable` protocol
extension Item: DefaultRepresentable {
    static var defaultValue: Self { 
        .init(name: "name", date: Date())
     }
}
```
```swift
// give default value
EditValueView(target, key: "item", keyPath: \Message.item, defaultValue: .init(name: "name", date: Date()))
```