> navigationController
> 

stack 처럼 쌓였다가 pop 되면 빠져나가게 되는 것 

( stack 에 나중에 들어온게 먼저 나가는 것) 

화면 전환 방법 

- **View Controller 의 View 위에 다른 View를 가져와 바꿔치기 → 메모리 누수의 위험, 지양하자**
- **View Controller에서 다른 View Controller 를 호출하여 전환하기**
- **Navigation Controller 를 사용하여 화면 전환하기**
    - present 메소드의 파라미터에 이동하려는 인스턴스 전달
- **화면 전환용 객체 세그웨이(Segueway) 를 사용하여 화면 전환하기**
    - 코드 없이 화면 전환 가능하게 짤 수 있다.
    ****

> ViewController Life Cycle
> 

화면 간 데이터 전달하기

- 코드로 구현된 화면 전환 방법에서 데이터 전달하기
    
    → `instantiateViewController` 메소드로  스토리보드 id 값 전달 
    
- 세그웨이로 구현된 화면 전환 방법에서 데이터 전달하기
    
    → `prepare` 메서드 오버라이드 사용해서 전환하려는 `instance` 를 가져오고 `property`에 접근하여 데이터를 전달 
    
- Delegate 패턴을 이용하여 이전 화면으로 데이터 전달하기 ( 많이 사용하는 편 )

> 에셋 카달로그 이미지 리소스 추가
> 

1x 

2x

3x
