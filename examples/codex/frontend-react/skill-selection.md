# Skill Selection Trace

> Profile에 포함된 skill과 preview 노출 방식을 기록한 dry-run example이다. Skill 설치나 실행 결과가 아니다.

## Common Skill — 6개

| Skill ID | 역할 | Load 기준 |
| --- | --- | --- |
| `common-incremental-implementation` | 변경 단계 분리 | 복합 UI 변경에서 load |
| `common-debugging` | 오류 재현과 원인 분석 | Rendering·async 실패 분석에서 load |
| `common-test-first` | 기대 UI 동작 선행 | 동작 변경에서 load |
| `common-code-review` | 정확성·설계·보안 검토 | Review 요청에서 load |
| `common-refactoring` | 동작 보존 구조 개선 | 명시적 refactoring에서 load |
| `common-security-review` | 외부 데이터·session·secret 검토 | 신뢰 경계 변경에서 load |

## Frontend Skill — 4개

| Skill ID | 선택 이유 | Load 기준 |
| --- | --- | --- |
| `frontend-component-design` | Component 책임과 props/state/data flow | Component 설계·변경 시 load |
| `frontend-state-management-review` | Local/global/server/cache state 소유권 | 상태 구조 검토 시 load |
| `frontend-api-client-integration` | REST contract, 오류, pagination과 session 연결 | API client 작업 시 load |
| `frontend-ui-error-handling` | 오류 message, retry 상태와 접근성 | UI failure 처리 시 load |

Testing category의 `testing-test-scope-selection` 1개를 포함해 총 11개 path가 profile과 registry에 일치한다.

## Routing과 Dependency

- Component design → incremental implementation + test-first: 충족
- State management review → code review: 충족
- API client integration, UI error handling → security review: 충족
- Test scope selection → test-first: 충족

Common skill은 작업 방식과 품질 gate를 제공한다. Frontend skill은 component, state, API client와 사용자 오류라는 UI 책임에만 적용한다. State library는 skill 선택만으로 확정하지 않는다.

## Inline 금지

Preview에는 skill ID, 짧은 역할과 trigger만 둔다. `SKILL.md` 본문, checklist와 예시는 inline하지 않고 작업 유형에 맞는 skill만 lazy load한다.

## 결과

11개 skill의 path와 hard dependency가 충족된다. 실제 skill 설치와 실행은 수행하지 않았다.
