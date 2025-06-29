## Swift Concurrency Demo

Swift 동시성 프로그래밍 개념 

- 5개 비동기 작업을 동시 실행하면서 Actor, TaskGroup, Async/Await, MainActor 동작 방식 확인

기능 
- 5개 비동기 작업 시뮬레이션
- 실시간 진행률 표시
- 각 작업의 완료 시간 기록 및 표시
- Actor를 통한 안전한 상태 관리 데모

# 1. Actor 
- 여러 비동기 작업이 동시에 같은 데이터에 접근할 때 발생할 수 있는 데이터 경합 문제
- Actor가 어떻게 내부 상태를 보호하는지 파악
- `await` 키워드를 통한 Actor 메서드 호출 방식
- 필요성: Actor 없이 일반 클래스를 사용하면 데이터 경합으로 인한 예측 불가능한 결과 및 크래시 발생할 수 있음


# 2 TaskGroup을 통한 구조적 동시성
동적으로 생성된 하위 작업을 포함하는 그룹
작업 그룹을 만들려면 withTaskGroup(of:반환:본문:) 메서드를 호출

작업 그룹을 만든 작업 외부에서 작업 그룹을 사용하면 안됨. 대부분의 경우 Swift 유형 시스템은 작업 그룹에 자식 작업을 추가하는 것은 변이 작업이고, 변이 작업은 자식 작업과 같은 동시 실행 컨텍스트에서 수행할 수 없기 때문에 작업 그룹이 그렇게 빠져나가는 것을 방지한다.

- `withTaskGroup`을 사용한 여러 작업의 동시 실행
- 모든 하위 작업이 완료될 때까지 대기하는 방식
- 작업 간 독립적 실행과 결과 수집

# 3. async/await 패턴

비동기 함수의 정의와 호출
Task.sleep을 통한 진정한 비동기 처리
콜백 지옥 없는 직관적인 비동기 코드 작성

# 4. MainActor를 통한 UI 안전성

- UI 업데이트가 반드시 메인 스레드에서 실행되어야 하는 이유
-  `@MainActor` 어노테이션과 MainActor.run 사용법
- 백그라운드 작업과 UI 업데이트의 분리

# 프로젝트 구조
```plainText
ConcurrencyDemo/
├── Models/
│   ├── TimeStore.swift              # Actor 정의
│   └── TestResultModel.swift        # UI 상태 관리 (@ObservableObject)
├── Services/
│   └── AsyncUtilities.swift         # 비동기 작업 유틸리티
├── Views/
│   └── ContentView.swift            # 메인 UI
└── Extensions/
    └── Extensions.swift             # 유틸리티 확장
```


# 테스트를 통해 알 수 있는 것

동시 시작: 모든 작업이 거의 동시에 시작됨
무작위 완료 순서: 각 작업마다 다른 지연 시간으로 완료 순서가 매번 다름
성능 향상: 순차 실행시 15초가 걸릴 작업이 약 3초만에 완료
데이터 안전성: 5개 작업이 모두 정상적으로 기록됨

# 성능 파악 포인트
- 순차 실행: 5 × 3초 = 15초
- 동시 실행: 최대 지연 시간인 약 3초
- seconds, milliseconds 가 아닌 nanoseconds로 설정한 이유 
   - 매우 정밀한 타이밍 제어 가능
   - 시스템 레벨에서 가장 정밀한 시간 단위
   - 일관성: 시스템 레벨 함수와 호환
   - 정확성: 정수 연산으로 부동소수점 오차 방지


### 결과화면

/ConcurrencyDemo/resultsConcurrency.gif