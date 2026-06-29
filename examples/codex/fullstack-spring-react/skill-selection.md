# Skill Selection Trace

> Profile에 포함된 skill과 preview 노출 방식을 기록한 dry-run example이다. Skill 설치나 실행 결과가 아니다.

## Common Skill — 8개

| Skill ID | 역할 | Load 기준 |
| --- | --- | --- |
| `common-incremental-implementation` | Fullstack 변경 단계 분리 | 복합 변경에서 load |
| `common-debugging` | Client/server 실패 재현과 원인 분석 | 오류 분석에서 load |
| `common-test-first` | 기대 동작과 회귀 조건 선행 | 동작 변경에서 load |
| `common-code-review` | 정확성·설계·보안 검토 | Review 요청에서 load |
| `common-refactoring` | 동작 보존 구조 개선 | 명시적 refactoring에서 load |
| `common-api-design-review` | Framework 중립 REST 계약 검토 | API 계약 검토에서 load |
| `common-security-review` | 입력·인증·권한·secret 검토 | 신뢰 경계 변경에서 load |
| `common-commit-worklog` | Git-auto 변경·검증 요약 | Git-auto 저장소 종료 시 load |

## Backend Skill — 4개

- `backend-service-layer-implementation`: Use case와 service 경계 변경
- `backend-repository-query-review`: Repository/query 검토
- `backend-transaction-boundary-review`: Transaction, retry와 외부 호출 경계 검토
- `backend-restful-api-design`: Backend REST contract 변경

## Database Skill — 2개

- `database-schema-change-review`: Schema, migration과 호환성 변경
- `database-query-performance-review`: Access pattern, index와 query 비용 검토

## Frontend Skill — 4개

- `frontend-component-design`: Component 책임과 props/state/data flow 변경
- `frontend-state-management-review`: Local/global/server/cache state 검토
- `frontend-api-client-integration`: Contract, pagination, session과 API client 연결
- `frontend-ui-error-handling`: 오류 message, retry 상태와 접근성 검토

## Testing 및 Automation — 각 1개

- `testing-test-scope-selection`: Unit, integration, contract와 e2e 범위 선택
- `automation-git-auto-workflow`: Hook 운영 또는 publisher pending 복구 시 참조

총 20개 skill path가 profile과 registry에 일치한다.

## 상시 Gate와 Lazy Loading

Preview에는 incremental implementation, test-first, API/security review, commit-worklog와 test scope의 짧은 gate만 둔다. Backend, database와 frontend skill은 실제 변경 책임이 일치할 때만 load한다. Debugging, code review, refactoring과 git-auto workflow도 해당 trigger에서만 참조한다.

Fullstack profile의 모든 skill 본문을 inline하면 서로 다른 작업 책임의 절차가 상시 context를 점유하고 fragment 규칙과 중복된다. 따라서 ID, 역할과 trigger만 노출하고 선택한 `SKILL.md` 본문만 lazy load한다.

## Dependency 확인

- Refactoring, test scope → test-first: 충족
- Service layer, component design → incremental implementation + test-first: 충족
- Repository, transaction, database, state review → code review: 충족
- Frontend API/error handling → security review: 충족
- Git-auto workflow → commit-worklog: 충족

## 결과

20개 skill의 path와 hard dependency는 모두 유효하다. Kotlin 선택은 profile의 skill 목록과 dependency를 바꾸지 않으므로 기존 routing을 유지한다. Language-specific skill을 추가하거나 본문을 inline하지 않았으며 실제 skill 설치와 실행도 수행하지 않았다.
