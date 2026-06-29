# Fragment Merge Trace

> `frontend-react` + Codex 수동 dry-run의 source 추적 문서다. 실제 merge engine 실행 결과가 아니다.

## 선택된 Fragment

| Profile 구분 | Catalog ID | Path | Priority |
| --- | --- | --- | --- |
| Base | `core-global` | `core/global/agents.fragment.md` | 10 |
| Base/project | `core-project` | `core/project/agents.fragment.md` | 70 |
| Quality | `core-quality` | `core/quality/agents.fragment.md` | 10 |
| Language | `language-javascript` | `stacks/language/javascript/agents.fragment.md` | 20 |
| API | `api-restful-api` | `stacks/api/restful-api/agents.fragment.md` | 30 |
| Frontend | `frontend-react` | `stacks/frontend/react/agents.fragment.md` | 40 |
| Bridge | `bridge-javascript-react` | `stacks/bridge/javascript-react/agents.fragment.md` | 50 |

Profile 참조 7개와 catalog path가 모두 일치했다.

## Preview 구성 및 Authority

표시 순서는 Core → JavaScript → React/REST API → JavaScript–React bridge → project placeholder다. Conflict authority는 priority 10, 20, 30, 40, 50, 70과 사용자 현재 요청 순으로 검토한다.

## Dependency와 Compatibility

- `core-project`, `core-quality` → `core-global`: 충족
- JavaScript와 RESTful API → `core-quality`: 충족
- React → JavaScript + core quality: 충족
- JavaScript + React → `requires-bridge`; `bridge-javascript-react` 선택됨
- React + RESTful API → `compatible`; required bridge 없음

Backend가 선택되지 않았으므로 `bridge-react-spring-api`를 추가하지 않았다. 이는 누락이 아니라 profile note와 compatibility catalog에 따른 경계다.

## REST Fragment와 API Client Skill 관계

`api-restful-api` fragment는 resource, HTTP 의미, error와 versioning 계약을 상시 요약한다. `frontend-api-client-integration` skill은 실제 API client 작업에서 contract mapping, session과 pagination 절차가 필요할 때만 참조한다. Fragment 규칙을 skill 본문으로 확장하거나 서로 대체하지 않는다.

## 중복과 충돌

- JavaScript async/error와 React effect/error 규칙은 language 책임과 lifecycle 연결로 분리했다.
- React API client 규칙과 REST 계약은 UI transport 경계와 protocol 계약으로 구분했다.
- Core REST 기본 원칙은 API fragment의 구체 계약으로 한 번만 요약했다.
- 특정 backend, build tool, package manager와 state library를 선택하지 않아 profile exclude와 충돌하지 않는다.

## 결과

Required bridge와 dependency가 해소되고 blocking conflict가 없다. Preview 결과는 `ready`이며 실제 export 대상이 아니다.
