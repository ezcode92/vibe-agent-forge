# Catalog Readiness 정책

## 목적

Catalog lifecycle status를 변경하지 않고 MVP generator가 선택 자산을 사용할 수 있는 조건과 severity를 정의한다. 이 정책은 `registry/*.yml`의 status를 자동 승격하거나 구현 readiness를 선언하지 않는다.

## 공통 판정 원칙

1. Catalog lifecycle, dry-run readiness, generator validation과 implementation readiness를 분리한다.
2. `draft`라는 이유만으로 fragment, skill 또는 profile을 차단하지 않는다.
3. 선택된 자산만 현재 요청의 readiness에 영향을 준다.
4. Path, dependency, bridge, variant와 conflict 오류는 lifecycle과 별도로 error다.
5. Dry-run 결과는 정확히 같은 profile, variant, adapter와 resolved source 집합에만 적용한다.

## 파생 Readiness 판정

| 판정 | 조건 | Generator severity | Catalog 변경 |
| --- | --- | --- | --- |
| `reviewed-for-mvp` | 선택 조합이 Codex `ready` dry-run과 정확히 대응 | Info | 없음 |
| `ready-candidate` | 구조·참조 검증은 통과하지만 정확한 `ready` dry-run 근거가 없음 | Warning | 없음 |
| `blocked` | 필수 source·dependency·bridge·variant·지원 adapter 또는 compatibility 검증 실패 | Error | 없음 |

`reviewed-for-mvp`와 `ready-candidate`는 validation report의 파생 판정이며 registry status 허용 값이 아니다.

## 자산별 정책

### Fragment

- Draft 허용: 선택 profile이 참조하고 path, ID mapping, dependency와 conflict 검증을 통과한다.
- Draft info: 대응 Codex `ready` dry-run의 resolved fragment 집합에 포함된다.
- Draft warning: 유효하지만 대응 dry-run coverage가 없다.
- Blocked: Path 또는 dependency 누락, conflict, required bridge 불일치가 있다.

### Skill

- Draft 허용: 선택 profile이 참조하고 path와 hard dependency가 유효하다.
- Draft info: 대응 Codex `ready` dry-run의 skill selection에 포함된다.
- Draft warning: 유효하지만 대응 dry-run coverage가 없다.
- Blocked: Path 또는 hard dependency가 누락됐다.

### Profile

- Draft 허용: Catalog/manifest ID와 path, count, constraint와 variant가 유효하다.
- Draft info: 같은 profile·variant의 Codex dry-run이 `ready`다.
- Draft warning: 정적 검증은 통과하지만 같은 profile·variant의 `ready` dry-run이 없다.
- Blocked: Profile 누락, path/count 불일치, required variant 미해결 또는 참조 오류가 있다.

### Adapter

- Codex: `mvp-contract`이므로 MVP generation target으로 허용한다.
- Claude/Gemini: `draft`이므로 MVP target 선택 시 error/blocked다.
- Adapter draft는 fragment/skill/profile draft와 달리 target output 계약 미확정을 뜻하므로 warning으로 진행하지 않는다.

### Compatibility Rule

- Selected `supported`: Relation과 required bridge를 검증하고 통과하면 허용한다.
- Selected `pending` 또는 unregistered: Error/blocked다.
- Unselected `pending`: 현재 resolved 조합과 무관하므로 ignored다. 전체 MVP readiness를 낮추지 않는다.

## Codex MVP 허용 범위

- `adapterId: codex`
- 기존 6개 `ready` dry-run과 정확히 대응하는 profile·variant·resolved source는 `reviewed-for-mvp`
- 그 밖의 구조적으로 유효한 draft profile·fragment·skill은 `ready-candidate` warning과 함께 검토 가능
- Selected compatibility는 모두 supported이고 required bridge가 해소돼야 함

## Claude/Gemini 후속 범위

Claude/Gemini adapter가 `draft`인 동안 MVP generation 대상으로 허용하지 않는다. 각 adapter가 독립 `mvp-contract`로 승격되고 대표 dry-run을 통과한 뒤 해당 adapter 기준의 `reviewed-for-mvp` 정책을 별도로 적용한다. Codex dry-run 결과를 다른 adapter coverage로 재사용하지 않는다.

## Catalog Status 승격 조건

Dry-run `ready`만으로 YAML status를 자동 승격하지 않는다. Fragment, skill 또는 profile status 승격은 다음 조건을 모두 검토하는 별도 변경이다.

1. Lifecycle 정책의 공통 승격 기준 충족
2. 대표 조합 coverage와 review 근거 기록
3. 인접 자산 책임·dependency·conflict 검토
4. Catalog 허용 status와 migration 영향 확정
5. 명시적 reviewer 승인 및 관련 문서 동시 갱신

현재 Phase 10-3에서는 registry YAML을 변경하지 않는다.
