# Fragment Merge Trace

> `fullstack-spring-react` + Codex Java variant 수동 dry-run의 source 추적 문서다. 실제 merge engine 실행 결과가 아니다.

## 선택된 Fragment — 15개

| Profile 구분 | Catalog ID | Path | Priority |
| --- | --- | --- | --- |
| Base | `core-global` | `core/global/agents.fragment.md` | 10 |
| Base/project | `core-project` | `core/project/agents.fragment.md` | 70 |
| Quality | `core-quality` | `core/quality/agents.fragment.md` | 10 |
| Backend language | `language-java` | `stacks/language/java/agents.fragment.md` | 20 |
| Frontend language | `language-javascript` | `stacks/language/javascript/agents.fragment.md` | 20 |
| Database | `database-rdb` | `stacks/database/rdb/agents.fragment.md` | 30 |
| API | `api-restful-api` | `stacks/api/restful-api/agents.fragment.md` | 30 |
| Architecture | `architecture-modular-monolith` | `stacks/architecture/modular-monolith/agents.fragment.md` | 30 |
| Framework | `framework-spring` | `stacks/framework/spring/agents.fragment.md` | 40 |
| Frontend | `frontend-react` | `stacks/frontend/react/agents.fragment.md` | 40 |
| Bridge | `bridge-java-spring` | `stacks/bridge/java-spring/agents.fragment.md` | 50 |
| Bridge | `bridge-spring-rdb` | `stacks/bridge/spring-rdb/agents.fragment.md` | 50 |
| Bridge | `bridge-spring-modular-monolith` | `stacks/bridge/spring-modular-monolith/agents.fragment.md` | 50 |
| Bridge | `bridge-javascript-react` | `stacks/bridge/javascript-react/agents.fragment.md` | 50 |
| Bridge | `bridge-react-spring-api` | `stacks/bridge/react-spring-api/agents.fragment.md` | 50 |

## Backend Language Variant

| Option | Fragment | Spring Bridge | 상태 |
| --- | --- | --- | --- |
| Java | `stacks/language/java/agents.fragment.md` | `stacks/bridge/java-spring/agents.fragment.md` | 선택 및 merge 완료 |
| Kotlin | `stacks/language/kotlin/agents.fragment.md` | `stacks/bridge/kotlin-spring/agents.fragment.md` | 이번 preview에서 제외, alternative 유지 |

Dry-run 입력으로 Java option 하나를 선택해 `exactly-one`을 해소했다. Kotlin option의 source는 profile과 별도 dry-run에 유지되지만 이번 resolved 집합에는 포함하지 않는다. Resolved fragment 수는 공통 13개 + Java 묶음 2개 = 15개다.

## Merge 순서와 Authority

표시 순서는 Core → Java/JavaScript → RDB/API/Modular Monolith → Spring/React → bridges → project override다. Conflict authority는 priority 10, 20, 30, 40, 50, 70과 사용자 현재 요청 순으로 검토한다.

## Dependency와 Compatibility

- Core project/quality → core global: 충족
- Java, JavaScript, RDB, REST API, Modular Monolith, Spring → core quality: 충족
- React → JavaScript + core quality: 충족
- Java + Spring → `bridge-java-spring` 선택, dependency와 compatibility 충족
- Spring–RDB, Spring–Modular Monolith, JavaScript–React, React–Spring API bridge: 모두 dependency 충족
- Kotlin + Kotlin–Spring bridge: 이번 resolved 집합에서 제외
- Exactly-one variant: Java 1개 선택으로 충족

## 중복 제거 후보

| 의미 영역 | 겹치는 Source | Dry-run 처리 |
| --- | --- | --- |
| 일반 품질·검증 | Core와 각 stack | 공통 원칙은 한 번만 유지하고 stack별 차이만 요약 |
| Java 객체/Spring layer | Java, Spring, Java–Spring bridge | 언어·framework 단독 규칙과 결합 규칙을 구분 |
| REST 계약 | Core quality, REST fragment, React–Spring bridge | HTTP 일반 원칙과 client/server 연결 규칙을 분리 |
| Transaction/RDB | Spring, RDB, Spring–RDB bridge | 독립 책임과 lifecycle 연결을 구분 |
| UI async/error | JavaScript, React, JavaScript–React bridge | 언어 비동기, UI lifecycle과 조합 규칙을 구분 |
| Module 경계 | Spring, Modular Monolith, 조합 bridge | Bean/module/table ownership 연결은 bridge에만 유지 |

## Conflict와 결과

- Java와 Kotlin을 동시에 선택하면 profile constraint 및 두 language–Spring bridge의 conflict를 위반한다.
- 이번 preview에는 Java 묶음만 포함돼 동시 선택 conflict가 없다.
- Java–Spring을 포함한 required bridge 5개가 모두 해소됐다.
- Blocking conflict가 없어 결과는 `ready`다. 이 trace는 수동 dry-run example이며 실제 export 결과가 아니다.
