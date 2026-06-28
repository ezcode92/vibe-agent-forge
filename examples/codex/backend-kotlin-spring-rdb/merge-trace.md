# Fragment Merge Trace

> `backend-kotlin-spring-rdb` + Codex 수동 dry-run의 source 추적 문서다. 실제 merge engine 실행 결과가 아니다.

## 선택된 Fragment

| Profile 구분 | Catalog ID | Path | Priority |
| --- | --- | --- | --- |
| Base | `core-global` | `core/global/agents.fragment.md` | 10 |
| Base/project | `core-project` | `core/project/agents.fragment.md` | 70 |
| Quality | `core-quality` | `core/quality/agents.fragment.md` | 10 |
| Language | `language-kotlin` | `stacks/language/kotlin/agents.fragment.md` | 20 |
| Framework | `framework-spring` | `stacks/framework/spring/agents.fragment.md` | 40 |
| Database | `database-rdb` | `stacks/database/rdb/agents.fragment.md` | 30 |
| API | `api-restful-api` | `stacks/api/restful-api/agents.fragment.md` | 30 |
| Architecture | `architecture-modular-monolith` | `stacks/architecture/modular-monolith/agents.fragment.md` | 30 |
| Bridge | `bridge-kotlin-spring` | `stacks/bridge/kotlin-spring/agents.fragment.md` | 50 |
| Bridge | `bridge-spring-rdb` | `stacks/bridge/spring-rdb/agents.fragment.md` | 50 |

Profile 참조 10개와 catalog path가 모두 일치했다.

## Preview Section 구성 순서

`docs/fragment-merge-strategy.md`의 출력 구성 순서에 따라 preview를 다음과 같이 읽기 쉽게 배열했다.

1. Core: global, project, quality
2. Language: Kotlin
3. Framework/platform: Spring
4. Database/API/architecture: RDB, RESTful API, Modular Monolith
5. Bridge: Kotlin–Spring, Spring–RDB
6. Project override: 실제 입력 없음

이 순서는 Markdown section 표시 순서이며 conflict authority를 뜻하지 않는다.

## Conflict 해결 Authority 순서

`registry/fragments.yml.priority`와 `docs/merge-policy.md`에 따라 낮은 priority에서 높은 priority로 검토했다.

1. Priority 10: `core-global`, `core-quality`
2. Priority 20: `language-kotlin`
3. Priority 30: `database-rdb`, `api-restful-api`, `architecture-modular-monolith`
4. Priority 40: `framework-spring`
5. Priority 50: `bridge-kotlin-spring`, `bridge-spring-rdb`
6. Priority 70: `core-project`
7. 사용자 현재 요청: 실제 generator 밖의 최종 권한

`core-project`는 실제 project 값이 아니라 공통 구조만 제공하므로 이 preview에서는 validation command와 scope를 placeholder로 유지했다. Profile override는 없다.

## Dependency 확인

- `core-project` → `core-global`: 충족
- `core-quality` → `core-global`: 충족
- Kotlin/Spring/RDB/REST/Modular Monolith → `core-quality`: 충족
- `bridge-kotlin-spring` → Kotlin + Spring: 충족
- `bridge-spring-rdb` → Spring + RDB: 충족

## Compatibility 확인

- Kotlin + Spring: `requires-bridge`, `bridge-kotlin-spring` 선택됨
- Spring + RDB: `requires-bridge`, `bridge-spring-rdb` 선택됨
- Spring + Modular Monolith: `bridge-pending`, 실제 required bridge ID 없음

마지막 관계는 incompatible이 아니지만 지원 완료도 아니므로 warning과 수동 검토 대상으로 남겼다.

## 중복 제거 후보

| 의미 영역 | 겹치는 Source | Dry-run 처리 |
| --- | --- | --- |
| 일반 검증·최소 변경 | Core global/quality와 각 stack 검증 section | 공통 원칙은 한 번만 두고 stack별 추가 검증만 유지 |
| REST 기본 품질 | Core quality와 RESTful API fragment | Core의 일반 기준은 축약하고 REST fragment의 contract 규칙으로 구체화 |
| Transaction | Spring, RDB, Spring–RDB bridge | 독립 원칙은 유지하고 둘 사이의 lifecycle 연결은 bridge에만 둠 |
| Null·coroutine | Kotlin과 Kotlin–Spring bridge | 언어 사용 원칙은 Kotlin에, binding/proxy/context 상호작용은 bridge에 둠 |
| Module/component 경계 | Modular Monolith와 Spring | 각 독립 경계는 유지하고 구체 연결은 pending warning으로 표시 |

실제 semantic deduplication engine이 없으므로 완전한 규칙 단위 제거를 수행하지 않고 preview 압축 시 반복 문장만 수동 축약했다.

## Conflict 후보

- Java 및 `bridge-java-spring`이 선택되지 않아 profile exclude 조건과 충돌하지 않았다.
- Monolith/MSA architecture가 선택되지 않아 architecture conflict가 없다.
- Required bridge 누락이 없다.
- Spring–Modular Monolith 관계는 pending이며 blocking conflict가 아니라 warning으로 분류했다.
- Project metadata와 정량 size budget 미확정은 warning이다.

## 결과

Fragment 집합은 Codex preview로 수동 구성 가능하다. 다만 merge engine이 없고 pending architecture bridge가 있으므로 결과는 `ready-with-warnings`이며 실제 export 대상이 아니다.
