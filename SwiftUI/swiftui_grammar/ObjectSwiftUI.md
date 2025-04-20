
 ###  SwiftUI 상태 프로퍼티, Observable, State, EnvironmentObject
 


- SwiftUI 는 데이터 주도 방식으로 앱을 개발한다. <br>
사용자 인터페이스 뷰들은 기본 데이터의 변경에 따른 처리 코드를
 작성하지 않아도 뷰가 업데이트 된다.<br>
->  데이터와 사용자 인터페이스 내의 뷰 사이 publisher(게시자) - subscriber(구독자) 관계를 형성한다.

### the Objects of SwiftUI
- @State (property)
- Observable object
- State Object
- Environment Object<br>
==> 모두 UI의 모양과 동작을 결정하는 상태를 제공하며, SwiftUI는 UI 레이아웃을 구성하는 뷰는 코드 내에서 직접<br> 업데이트 하지 않는다. 대신 뷰와 바인딩된 상태 객체가 시간이 지남에 따라 변하면 그 상태에 따라 자동으로 뷰가 업데이트 된다.

> 상태 프로퍼티

상태에 대한 가장 기본적인 형태, 뷰 레이아웃의 현재 상태를 (예를 들어, 토글 버튼이 활성화되었는지 여부, 텍스트 필드에 입력된 텍스트, 또는 피커 뷰에서의 현재 선택) 저장하기 위해 사용

=> 간단한 `Int`, `String` 같은 간단한 데이터 타입을 저장하기 위해 사용하며, @State 프로퍼티 래퍼를 사용하며 선언

- 상태 프로퍼티 값이 변경되면 그 프로퍼티가 선언된 뷰 계층 구조를 렌더링 한다. 즉, 그 프로퍼티에 의존하는 모든 뷰는 최신 값이 반영되어 업데이트함.
- 상태 프로퍼티를 선언했다면 레이아웃에 있는 뷰와 바인딩 할 수 있음. 
바인딩 되어 있는 뷰에서 어떤 변경이 일어나면 해당 상태 프로퍼티에 자동 반영됨
- 상태 프로퍼티와의 바인딩은 프로퍼티 이름 앞에  `$` 를 붙인다. 

```Swift
struct ContentView: View {
    @State private var wifiEnabled = true
    @State private var userName = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Toggle(isOn: $wifiEnabled) {
                Text("Enable WiFi")
            }
            TextField("Enter User name", text: $userName)
            Text(userName)
            Image(systemName: wifiEnabled ? "wifi" : "wifi.slash")
        }
        .padding()
    }
}

```


> State 바인딩

위에서 언급한 상태 프로퍼티는 선언된 뷰와 그 하위 뷰에 대한 **현재 값**이다.
그렇지만, 어떤 뷰는 동일한 상태 프로퍼티에 대해 하나 이상의 하위 뷰를 가지고, 동일한 상태 프로퍼티에 대해 접근해야 하는 경우

```Swift
import SwiftUI

struct ContentView: View {
    @State private var wifiEnabled = true
    @State private var userName = ""
    
    var body: some View {
        VStack(alignment: .center) {
            Toggle(isOn: $wifiEnabled) {
                Text("Enable WiFi")
            }
            // ... 
            WifiImageView(wifiEnabled: $wifiEnabled)
        }
        .padding()
    }
}

struct WifiImageView: View {
    @Binding var wifiEnabled: Bool
    var body: some View {
        Image(systemName: wifiEnabled ? "wifi" : "wifi.slash")
            
    }
}
```
WifiImageView 하위 뷰는 wifiEnable 상태 프로퍼티에 접근해야한다. 분리된 하위 뷰 요소인 Image 뷰는 
메인뷰의 범위 밖이다. 
-> 즉, WifiImageView 입장에서 보면 wifiEnabled 프로퍼티는 정의되지 않은 변수다. 
이 문제는 위 코드와 같이 `@Binding` 이라는 프로퍼티 래퍼를 이용해 프로퍼티를 선언해 해결한다.

```Swift
@Binding var wifiEnable: Bool 
```


[ 실행할 수 있는 xcode 프로젝트 코드]
[examObjectOfSwiftUI](https://github.com/cestbonciel/iOS-TIL/tree/swiftui/SwiftUI/swiftui_grammar/examObjects)