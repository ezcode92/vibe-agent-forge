# Fragment Merge Trace

> `fullstack-spring-react` + Codex 수동 dry-run의 source 추적 문서다. 실제 merge engine 실행 결과가 아니며 variant 미선택 때문에 최종 merge는 수행하지 않았다.

## 공통 선택 Fragment — 13개

| Profile 구분 | Catalog ID | Path | Priority |
| --- | --- | --- | --- |
| Base | `core-global` | `core/global/agents.fragment.md` | 10 |
| Base/project | `core-project` | `core/project/agents.fragment.md` | 70 |
| Quality | `core-quality` | `core/quality/agents.fragment.md` | 10 |
| Language | `language-javascript` | `stacks/language/javascript/agents.fragment.md` | 20 |
| Database | `database-rdb` | `stacks/database/rdb/agents.fragment.md` | 30 |
| API | `api-restful-api` | `stacks/api/restful-api/agents.fragment.md` | 30 |
| Architecture | `architecture-modular-monolith` | `stacks/architecture/modular-monolith/agents.fragment.md` | 30 |
| Framework | `framework-spring` | `stacks/framework/spring/agents.fragment.md` | 40 |
| Frontend | `frontend-react` | `stacks/frontend/react/agents.fragment.md` | 40 |
| Bridge | `bridge-spring-rdb` | `stacks/bridge/spring-rdb/agents.fragment.md` | 50 |
| Bridge | `bridge-spring-modular-monolith` | `stacks/bridge/spring-modular-monolith/agents.fragment.md` | 50 |
| Bridge | `bridge-javascript-react` | `stacks/bridge/javascript-react/agents.fragment.md` | 50 |
| Bridge | `bridge-react-spring-api` | `stacks/bridge/react-spring-api/agents.fragment.md` | 50 |

## Backend Language Variant — 2개 중 한 묶음

| Option | Fragment | Spring Bridge | 상태 |
| --- | --- | --- | --- |
| Java | `stacks/language/java/agents.fragment.md` | `stacks/bridge/java-spring/agents.fragment.md` | `selection-required` |
| Kotlin | `stacks/language/kotlin/agents.fragment.md` | `stacks/bridge/kotlin-spring/agents.fragment.md` | `selection-required` |

Profile은 `exactly-one`을 요구한다. 두 option은 모두 존재하고 각 bridge dependency도 유효하지만 실제 project 입력이 없어 어느 묶음도 선택하지 않았다. 동시 선택은 profile exclude와 bridge conflict를 위반한다. Resolved fragment 수는 공통 13개 + 선택 묶음 2개 = 15개다.

## Merge 순서와 Authority

최종 선택 후 표시 순서는 Core → backend language/JavaScript → RDB/API/Modular Monolith → Spring/React → bridges → project override다. Conflict authority는 priority 10, 20, 30, 40, 50, 70과 사용자 현재 요청 순으로 검토한다. Variant 미선택 상태에서는 language-specific merge를 실행하지 않는다.

## Dependency와 Compatibility

- Core project/quality → core global: 충족
- JavaScript, RDB, REST API, Modular Monolith, Spring → core quality: 충족
- React → JavaScript + core quality: 충족
- Spring–RDB, Spring–Modular Monolith, JavaScript–React, React–Spring API bridge: 모두 dependency 충족
- Java option → Java + Spring + Java–Spring bridge: source와 dependency 존재
- Kotlin option → Kotlin + Spring + Kotlin–Spring bridge: source와 dependency 존재
- Java/Kotlin option 선택: 미수행, required variant error

## 중복 제거 후보

| 의미 영역 | 겹치는 Source | Dry-run 처리 |
| --- | --- | --- |
| 일반 품질·검증 | Core와 각 stack | 공통 원칙은 한 번만 유지하고 stack별 차이만 요약 |
| REST 계약 | Core quality, REST fragment, React–Spring bridge | HTTP 일반 원칙과 client/server 연결 규칙을 분리 |
| Transaction/RDB | Spring, RDB, Spring–RDB bridge | 독립 책임과 lifecycle 연결을 구분 |
| UI async/error | JavaScript, React, JavaScript–React bridge | 언어 비동기, UI lifecycle과 조합 규칙을 구분 |
| Module 경계 | Spring, Modular Monolith, 조합 bridge | Bean/module/table ownership 연결은 bridge에만 유지 |
| API client | React, REST, frontend skill | 상시 contract는 fragment, 작업 절차는 lazy-loaded skill로 분리 |

## Conflict와 결과

- Java와 Kotlin을 동시에 선택하면 profile constraint 및 두 language–Spring bridge의 conflict를 위반한다.
- 둘 다 선택하지 않으면 required variant와 대응 bridge가 해소되지 않는다.
- 공통 13개 fragment에서는 blocking conflict가 발견되지 않았다.
- 현재 결과는 `selection-required` error 1건으로 `blocked`다. 이 trace는 선택 후 최종 merge를 위한 진단 자료이며 실제 export 결과가 아니다.
