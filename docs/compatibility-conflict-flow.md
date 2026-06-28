# Compatibility 및 Conflict Flow

## 목적

선택한 fragment 관계를 registry compatibility와 conflict metadata에 대조하고 사용자가 해결 방향을 판단할 수 있게 하는 흐름을 정의한다. 자동 수정 없이 근거와 추천만 제공한다.

## Compatibility Matrix 사용 방식

1. 선택된 fragment ID 쌍으로 `compatibility-matrix.yml`의 source/target을 조회한다.
2. Matching entry의 relation, required bridge, status와 notes를 읽는다.
3. Required bridge가 있으면 `fragments.yml`에서 실제 bridge, dependency와 path를 확인한다.
4. Entry가 pending이면 존재하지 않는 bridge를 생성하지 않고 보류 관계로 표시한다.
5. Entry가 없으면 compatible로 추정하지 않고 미등록 관계로 표시한다.

Matrix는 방향성 entry이므로 source와 target을 임의로 뒤집거나 transitive 관계를 자동 생성하지 않는다.

## UI 관계 상태

| UI 상태 | Catalog 해석 | 의미 |
| --- | --- | --- |
| `compatible` | `relation: compatible`, `status: supported` | 추가 bridge 없이 조합 검토 가능 |
| `requires_bridge` | `relation: requires-bridge`, bridge ID 존재 | 해당 bridge를 함께 선택해야 함 |
| `incompatible` | Fragment `conflicts_with` 또는 향후 명시적 incompatible relation | 동시에 선택할 수 없음 |
| `optional` | 필수는 아니지만 현재 조합에서 유용한 bridge/skill 추천 | 사용자 판단으로 선택 |
| `pending` | `status: pending` 또는 bridge 미구현 | 지원 완료가 아니며 보류 또는 profile 변경 필요 |
| `unregistered` | Matrix entry 없음 | 관계를 추정할 근거가 없음 |

`optional`은 현재 matrix의 확정 relation이 아니라 UI 추천 상태다. 추천 근거와 미선택 영향을 설명할 수 있을 때만 사용한다.

## Conflict 탐지 기준

### Blocking Conflict

- 선택 fragment가 서로의 `conflicts_with`에 포함된다.
- 필수 `depends_on`이 선택되지 않았다.
- `requires_bridge` 관계의 bridge가 누락됐다.
- `exactly-one` variant가 선택되지 않거나 둘 이상 선택됐다.
- 선택 bridge의 dependency stack이 누락됐다.

### Warning 또는 수동 결정

- Compatibility 관계가 pending 또는 unregistered다.
- Adapter가 선택 output을 지원하지 않는다.
- 같은 의미 영역의 규칙이 서로 다른 소유자나 우선순위를 요구한다.
- Profile count 또는 catalog version이 source와 다르다.
- Optional 추천을 선택하지 않아 기능 제한이 생긴다.

## Conflict Resolver 표시 정보

| 정보 | 내용 |
| --- | --- |
| Conflict ID | UI session 안에서 추적할 임시 식별자 |
| 유형·심각도 | Conflict, missing dependency, pending, unsupported 등 |
| Source | 관련 fragment/profile/adapter ID와 path |
| 규칙 | `depends_on`, `conflicts_with`, matrix relation 또는 variant constraint |
| 영향 | Preview 차단, 기능 제한, 의미 손실 또는 수동 검토 필요 |
| 추천 | 제거, bridge 추가, profile 변경 또는 pending 보류 |
| 근거 | Catalog field와 notes |
| 사용자 결정 | 선택한 해결 방식과 간단한 이유 |

## 해결 방식

### Fragment 제거

- Conflict를 일으키는 선택 중 project 목적에 필수적이지 않은 항목을 제거한다.
- 제거로 인해 dependency와 skill 추천이 추가로 깨지는지 다시 검사한다.

### Bridge 추가

- Matrix가 `requires_bridge`이고 실제 bridge ID가 존재할 때만 추천한다.
- Bridge dependency가 모두 선택됐는지 확인한다.

### Profile 변경

- 현재 project type과 필수 stack이 profile의 기본 조합과 크게 다르면 더 적합한 profile로 이동한다.
- 기존 선택을 조용히 버리지 않고 변경 차이를 보여 준다.

### Pending 상태로 보류

- 필요한 bridge 또는 설계 책임이 아직 없고 위험을 수용할 수 있을 때만 선택한다.
- Pending 이유, preview 영향과 해소 조건을 기록한다.
- Blocking security 또는 data integrity conflict는 pending으로 우회하지 않는다.

## 재검증 흐름

사용자 해결 선택 → Fragment/bridge/profile 선택 갱신 → Dependency/conflict 재계산 → Compatibility 재조회 → 남은 warning 확인 → Preview readiness 판정

Resolver는 추천을 적용한 결과를 미리 보여 줄 수 있지만 실제 선택 변경은 사용자 승인 후의 UI 상태에서만 반영한다.

## 현재 범위

Conflict 자동 수정, 최적 조합 탐색, catalog 쓰기와 정책 학습은 구현하지 않는다. 현재 흐름은 수동 해결을 지원하는 설명과 추천 기준만 정의한다.
