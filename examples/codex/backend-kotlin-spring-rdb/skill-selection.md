# Skill Selection Trace

> Profile에 포함된 skill과 preview 노출 방식을 기록한 dry-run example이다. Skill 설치나 실행 결과가 아니다.

## Profile 포함 Skill

### Common Skill — 7개

| Skill | 역할 | Load 정책 |
| --- | --- | --- |
| `common-incremental-implementation` | 큰 변경의 단계 분리 | 복합 구현 작업에서 load |
| `common-debugging` | 재현·가설·최소 수정 | 버그/실패 분석에서 load |
| `common-test-first` | 기대 동작과 회귀 검증 선행 | 동작 변경에서 load |
| `common-code-review` | 정확성·설계·보안·test 검토 | Review 요청에서 load |
| `common-refactoring` | 동작 보존 구조 개선 | 명시적 refactoring에서 load |
| `common-security-review` | 입력·권한·secret 위험 검토 | 신뢰 경계 변경에서 load |
| `common-commit-worklog` | Git-auto 작업 요약과 종료 정책 | Git-auto 저장소 종료 시 load |

### Backend Skill — 4개

| Skill | 역할 | Load 정책 |
| --- | --- | --- |
| `backend-service-layer-implementation` | Use case, business rule와 계층 경계 | Service 구현 시 load |
| `backend-repository-query-review` | Repository/query 정확성·조회 범위 | Query 변경 review 시 load |
| `backend-transaction-boundary-review` | Read/write, 외부 호출과 retry 경계 | Transaction 변경 시 load |
| `backend-restful-api-design` | Backend REST contract 설계 | API 추가·변경 시 load |

### Database Skill — 2개

| Skill | 역할 | Load 정책 |
| --- | --- | --- |
| `database-schema-change-review` | Schema 호환성, migration과 복구 | Schema 변경 시 load |
| `database-query-performance-review` | Access pattern, index와 query 비용 | 성능 검토 시 load |

### Testing 및 Automation — 각 1개

| Skill | 역할 | Load 정책 |
| --- | --- | --- |
| `testing-test-scope-selection` | 변경에 맞는 test 수준 선택 | 검증 범위 결정 시 load |
| `automation-git-auto-workflow` | Hook workflow와 pending 복구 | Git-auto 운영/실패 복구 시 load |

총 15개 path가 profile 및 `registry/skills.yml`과 일치했다.

## Preview에 상시 포함하는 항목

Skill 본문을 상시 포함하지 않는다. `AGENTS.preview.md`에는 다음 짧은 routing/gate만 유지한다.

- 큰 변경은 incremental implementation을 사용한다.
- 동작 변경은 test-first와 test scope를 검토한다.
- 신뢰 경계 변경은 security review를 적용한다.
- Git-auto 저장소에서는 commit-worklog 정책에 따라 직접 commit·push하지 않는다.
- 작업 유형이 backend/database/automation 절차와 일치하면 해당 skill을 선택한다.

이는 skill 활성화가 아니라 언제 찾아야 하는지를 알려 주는 진입 규칙이다.

## 필요 시 참조하는 Skill

- Debugging, code review와 refactoring은 해당 요청이 있을 때만 load한다.
- Service, repository, transaction과 REST API skill은 변경 책임이 일치할 때만 load한다.
- Schema와 query performance skill은 database 변경·성능 작업에서만 load한다.
- Git-auto workflow는 publisher 복구 또는 hook 운영 진단이 필요할 때만 load한다.

Profile에 포함됐다는 이유만으로 모든 skill을 동시에 활성화하지 않는다.

## Dependency 확인

- `common-refactoring` → `common-test-first`: 충족
- `backend-service-layer-implementation` → incremental + test-first: 충족
- Repository/transaction/database review → `common-code-review`: 충족
- `testing-test-scope-selection` → `common-test-first`: 충족
- `automation-git-auto-workflow` → `common-commit-worklog`: 충족

Hard dependency가 없는 참고 문서는 dependency로 승격하지 않았다.

## Token 절약 원칙

- Catalog metadata와 skill ID로 discovery한다.
- Trigger를 확인한 뒤 해당 `SKILL.md` 본문만 읽는다.
- Common workflow와 stack-specific 차이를 중복 load하지 않는다.
- Skill 본문을 `AGENTS.preview.md`에 직접 복사하지 않는다.
- 선택되지 않은 product-specific 정보와 긴 reference를 읽지 않는다.

## 결과

15개 skill은 profile 후보 집합으로 유효하고 dependency도 충족한다. Preview에는 압축된 routing만 포함했으며 실제 skill directory 설치와 adapter mapping은 수행하지 않았다.
