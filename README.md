# 📱프로젝트명: 계산기

## 🐶 App소개
<img src="https://user-images.githubusercontent.com/39155090/142417199-0dfa73e8-2ffa-4170-b598-d89b338a89cb.gif" width="300" height="600">


## 🐺 코드이해자료
### ✔ App 구동 Flow
1. 버튼이 눌리면 IBAction 호출
2. (`IBAction`에서) runButtonAction 호출 (+버튼종류가 무엇인지와 함께)
3. (`runButtonAction`에서) ButtonActionDelegate 프로토콜에 정의된 runAction 호출 (+뷰컨정보도 담아서)
4. (`runAction`에서) 파라미터로 전달된 뷰컨정보에서 phase를 읽어 그에 맞는 메서드 호출

![image](https://user-images.githubusercontent.com/39155090/142367830-693742c3-e71f-48c5-85db-0bc9d3b6b775.png)

### ✔ 버튼별/Phase별 Action matrix
![image](https://user-images.githubusercontent.com/39155090/142365619-1795113e-d6f6-4f13-81f2-7fb7082f3ab5.png)


### ✔ Model layer UML
![image](https://user-images.githubusercontent.com/39155090/141436054-0665afc5-aa0c-44e2-be0d-6bf4bbe13580.png)

---
<br>

## 🦊 확장성을 고려한 설계 (열거형 vs 프로토콜)

### ✔ 열거형 vs 프로토콜
유사한 역할을 맡은 여러 타입을 묶는 방식으로 열거형을 쓸 수도 있고, 공통적으로 채택할 프로토콜을 만들 수도 있습니다
각 방식은 App의 '확장성'측면에서 사용되기에 유리한 상황이 다릅니다
- 열거형 : 행위(메서드)가 변경될 것 같은 경우
- 프로토콜 : case(타입)가 변경될 것 같은 경우

### ✔ 계산기를 프로토콜로 설계한 이유
계산기라는 App 특성상 Phase가 추가/변경되긴 어려우나,
버튼의 종류(ex. 로그함수)는 충분히 늘어날 수 있을 것으로 예상할 수 있습니다

버튼을 추가할 때, 뷰컨의 코드는 최대한 건드리지 않고
추가해야할 코드를 최소화하고 한 부분에만 집중되도록 ButtonActionDelegate라는 프로토콜을 두었습니다

이제 새로운 종류의 버튼을 추가하려면, 다른 코드는 거의 건드릴 필요없이
ButtonActionDelegate를 준수하는 새로운 Handler 타입을 추가하기만 하면 됩니다

### ✔ 프로토콜 사용 시, extension으로 상속처럼 사용할 수 있다
해당 프로토콜을 채택하는 여러 타입들이 서로 다른 기능을 해야 하는 메서드는 '요구사항'으로,
모두 같은 기능을 해야 하는 메서드는 'extension'으로 만들어주면 코드 중복을 최소화할 수 있습니다

---
<br>

## 🐔 Class vs Struct
### ✔ **기본적으로 struct를 사용하는게 좋다**
값타입 인스턴스는 이를 변경할 수 있는 범위(scope)가 좁아 신경써야 하는 코드영역이 좁아서 안정성을 확보하기 더 쉽습니다
(예로, 한 함수에서 생성된 값타입 인스턴스는 함수종료와 함께 반드시 사라지지만, 클로저같은 참조타입은 밖으로 나가서는 어디서 무슨 짓을 하고 다닐지 생각해야 하는..)

### ✔ **class를 사용해야 하는 경우**
- Objective-C의 API와 상호작용해야 하는 경우
- 여기저기 공유가 필요하여 참조타입으로 사용해야 하는 경우

---
<br>

## 🐰 TDD 활용
### ✔ TDD를 사용하며 느낀점
- 단점 : 테스트 코드를 짜기 위해 추가적인 시간이 '꽤나' 걸린다
- 장점 : 어떤 기능(메서드)에 대해 한 번만 Setup 해놓으면 계속 쓸 수 있다. 리팩터링을 매우 안정감있게 할 수 있다. 결국, brain power를 아끼는 지름길

### ✔ 테스트 커버리지 활용
테스트 케이스를 만들 때, 가장 큰 고민이 '어디까지 만들어야 할까'였다

처음에는 생각나는대로 케이스를 추가했었는데 이 정도면 충분한가? 하던 중
테스트 커버리지 100%를 목표로 해보는 것도 좋겠다는 생각이 들었다
(이 과정에서 '생각나는대로' 주었던 테스트케이스가 부족했고 코드에 홀이 있었음을 발견하기도 했음)

---
<br>

## 🦀 Rules for Clean Code
- 같은 개념을 표현하는 단어는 코드 전체적으로 통일해야 헷갈리지 않는다
- 조건문에 `== true`가 굳이 붙지 않게 만드는게 좋다
(ex. `isEmpty == false` 대신 `isNotEmpty`를 만들기)
- 긴 구문이 반복적으로 사용되면 별도의 변수로 할당해주는게 가독성에 좋다 (메모리 걱정일랑ㄴㄴ 컴파일러가 알아서 최적화)
- 하드코딩은 최대한 배제 (기능추가 혹은 리팩터링하며 만병의 근원이 됨)
- 변수명이 (생각보다) 모든 표현을 담지 않아도 된다 (문맥으로 잘 읽힐수도 있다)
- 프로퍼티는 (어지간하면) 외부에서 직접 변경하지 못하도록 접근제어 설정할 것

---
<br>

## 🐺 고차함수 활용
**고차함수가 왜 좋을까?**
- 반복문의 중간결과를 별도 변수에 저장할 필요가 없어 (어지간하면) 상수만 사용할 수 있음
- for문보다 성능적 이점을 가짐
- 축약표현(`$0`)으로 가독성 up

---
<br>

## 🐸 Result vs try-catch
보통 비동기 작업에 대한 에러처리가 필요하면 Result가 사용됩니다

### ✔ Result 장점
`try-catch`를 사용하면 catch가 모든 Error 타입을 커버해야 합니다.
반면, `Result`는 '특정 Error타입(여기선 ParserError)'을 지정하고 
그에 대해서만 switch문 case를 만들어주면 됩니다

### ✔ Result 단점
에러를 유발하는 부분(throw)과 에러를 처리하는 부분(catch)가 멀고 
함수가 함수를 호출하는 recursive한 구조일 때는 try-catch가 훨씬 유리

---
<br>

## 🦁 기타 고민한 점
- 어떤 기능(메서드)을 어느 타입에 구현해야 할까
(-> 각 타입의 역할을 되짚어보면 답이 나온다)
- caseless열거형의 용도
(메서드만 가지는 타입이 필요한 경우)
(다만, delegate패턴에 사용되려면 인스턴스화가 필요하므로 struct로 대체)
- Swift 기본 라이브러리는 암시적으로 import되므로 명시할 필요가 없다
- 하나의 target 내에는 같은 이름의 파일이 존재할 수 없다
(= target이 다르면, 이름이 같아도 된다)
