# Generator Validation Report

## 목적

Generator pipeline의 검증 결과를 항목별 severity, source, 영향과 preview 가능 상태로 일관되게 보고하는 구조를 정의한다. Report는 오류가 있어도 가능한 진단을 반환하며 실패를 숨기지 않는다.

## Report 구조

| 필드 | 의미 |
| --- | --- |
| Report ID | 한 preview 시도의 논리적 식별자 후보 |
| Profile/adapter | 선택 입력과 target |
| Overall status | `passed`, `passed-with-warnings`, `failed` |
| Preview status | `ready`, `ready-with-warnings`, `blocked` |
| Checks | 검증 항목별 결과 목록 |
| Summary | Severity별 개수와 핵심 차단 사유 |
| Not-run stages | 선행 실패로 수행하지 못한 pipeline 단계 |

각 check는 code, severity, status, message, source ID/path, pipeline stage, 영향과 권장 조치를 가진다.

## Phase 11 Report 형식 우선순위

1. Canonical machine-readable logical report를 source of truth로 구현한다.
2. 사람이 읽는 Markdown report는 canonical report에서 파생하는 secondary representation으로 둔다.
3. Initial increment는 in-memory structured result를 우선하며 JSON/YAML schema file과 Markdown file materialization은 만들지 않는다.

Machine-readable 우선은 API endpoint나 특정 serialization format을 확정한다는 뜻이 아니다. Field 의미, ordering과 readiness가 안정된 뒤 serialization format을 별도 결정한다.

## Phase 11 최소 Report 항목

- Selected profile, variant, adapter와 mode
- 사용한 catalog version과 source provenance
- Check code, severity, status, message와 pipeline stage
- 관련 source ID/path와 영향
- Error/warning/info count와 blocking root cause
- `not-run` 단계와 선행 실패
- `reviewed-for-mvp` 또는 `ready-candidate`
- `ready`, `ready-with-warnings` 또는 `blocked`
- `writePerformed: false`와 protected-file invariant 결과

## Severity 정의

### Error

- 정확한 입력 해석 또는 안전한 preview를 보장할 수 없다.
- 자동 추정이나 사용자 warning 수용으로 우회할 수 없다.
- Overall status를 failed, preview를 blocked로 만든다.

### Warning

- Preview는 가능하지만 미구현·불확실성·길이·미지원 기능으로 수동 검토가 필요하다.
- Source, 영향과 수용 조건이 명확해야 한다.
- 사용자 수용이 실제 오류를 성공으로 바꾸지는 않는다.

### Info

- 선택, deduplication, optional 미선택과 provenance 등 결과 이해를 돕는다.
- Preview readiness를 낮추지 않는다.

## 최소 검증 항목

| Check | 기본 severity | 성공 기준 | 실패 결과 |
| --- | --- | --- | --- |
| YAML parse | Error | Catalog/profile YAML이 예상 구조로 parse됨 | Load 중단, preview blocked |
| Path existence | Error | Pending 제외 필수 source/template 존재 | 해당 resolve 중단 |
| Duplicate ID | Error | Catalog namespace 안 ID 유일 | 임의 항목 선택 금지 |
| Missing dependency | Error | Fragment/skill hard dependency 충족 | Resolved context 확정 불가 |
| Selected draft profile/fragment/skill | Info 또는 Warning | `reviewed-for-mvp` coverage 또는 `ready-candidate` 근거 존재 | Coverage가 있으면 info, 없으면 warning |
| Exactly-one variant | Error | Required variant에서 정확히 하나의 option 선택 | 미선택·복수 선택·알 수 없는 option이면 blocked |
| Unresolved optional item | Warning | Optional 추천의 선택 여부와 영향 기록 | 필수 조건이 아니면 manual review |
| Compatibility violation | Error | Incompatible relation 없음 | Conflict 해결 전 blocked |
| Pending compatibility | Error | Resolved relation이 모두 supported이고 pending/unregistered가 없음 | 초기 MVP에서는 blocked |
| Unselected pending compatibility | Ignored | Resolved 조합에 relation이 포함되지 않음 | Check와 readiness 집계에서 제외 |
| Missing bridge | Error | 존재하는 required bridge 선택 | 누락 또는 존재하지 않는 bridge면 blocked |
| Unsupported adapter feature | Error 또는 Warning | Codex 필수 output 지원 | 필수 target/output이면 blocked, optional capability면 warning |
| Output length warning | Info, Warning 또는 Error | `docs/output-size-budget.md`와 profile 한도 안에 있고 skill body inline이 없음 | 목표 초과는 warning, error 기준·inline 위반은 blocked |
| Protected file touched | Error | Generator 전체 실행에서 protected file write가 없음 | Invariant 위반으로 blocked |

## 추가 권장 검증

- Profile count와 resolved 구성 수의 일치
- Profile path와 catalog ID mapping
- Bridge dependency completeness
- 미치환 필수 template placeholder
- Skill trigger와 lazy loading 상태
- Merge policy와 catalog numeric priority 일치
- 기존 git-auto policy를 약화하는 output 포함 여부

## Catalog Status 판정

- 선택 profile, fragment와 skill이 `draft`인 사실만으로 warning이나 error를 만들지 않는다.
- 같은 profile·variant·Codex adapter와 resolved source가 `ready` dry-run에 있으면 `reviewed-for-mvp` info를 기록한다.
- 구조·참조 검증은 통과하지만 정확한 dry-run coverage가 없으면 `ready-candidate` warning을 기록한다.
- Missing path, dependency, conflict와 variant 오류는 draft warning으로 낮추지 않고 각각 error다.
- Codex adapter `mvp-contract`는 허용한다. Claude/Gemini `draft` adapter를 target으로 선택하면 unsupported target error다.
- Selected pending/unregistered compatibility는 error다. Unselected pending entry는 ignored이며 전체 catalog에 존재한다는 이유만으로 report readiness를 낮추지 않는다.

세부 coverage와 승격 기준은 `catalog-readiness-policy.md`를 따른다.

## Generator 실패 조건

- Registry 또는 profile의 필수 YAML을 parse할 수 없다.
- Selected profile/adapter 또는 필수 path가 없다.
- Duplicate ID 때문에 참조가 모호하다.
- Required dependency, variant 또는 bridge가 미해결이다.
- Pending 또는 unregistered compatibility가 resolved 입력에 포함된다.
- Incompatible fragment가 동시에 선택됐다.
- Semantic conflict를 priority와 근거로 해결할 수 없다.
- Adapter의 필수 preview target/template이 없다.
- Validation report 자체를 완성할 수 없다.
- Root `AGENTS.md`, `.codex/hooks`, `.codex/hooks.json` 또는 `.gitauto/`에 write가 감지된다.

실패 시에도 확인된 error와 not-run 단계는 반환한다. Partial preview를 완성 결과처럼 표시하지 않는다.

## Preview 가능 조건

- Error가 0개다.
- Required reference, dependency, bridge와 variant가 해소됐다.
- Adapter template 및 필수 metadata가 존재한다.
- Warning이 source, 영향과 수동 결정 상태를 가진다.
- File write가 수행되지 않는다.

초기 MVP에서 pending 또는 unregistered 관계는 error이므로 `ready-with-warnings`로 낮출 수 없다.

## Lifecycle Readiness 판정

- `ready`: Error 0, Warning 0, 모든 필수 check passed, 필수 `not-run` 없음.
- `ready-with-warnings`: Error 0, 모든 필수 check passed, 각 warning의 source·영향·수동 조치가 기록됨.
- `blocked`: Error가 하나 이상이거나 선행 error 때문에 필수 check를 완료하지 못함.

이 판정은 `lifecycle-status-policy.md`와 동일하다. Warning 0만으로 필수 check 누락이나 `not-run`을 성공으로 간주하지 않는다.

## Protected File 기준

- MVP generator는 어떤 filesystem write도 수행하지 않으므로 protected file touched의 정상 결과는 항상 passed다.
- Root `AGENTS.md`, `.codex/hooks`, `.codex/hooks.json`, `.gitauto/` 또는 target project file 변경이 관찰되면 error다.
- `export-plan`의 target path 표시는 write가 아니며 `writePerformed: false`를 유지한다.

## Output Length 처리

- `docs/output-size-budget.md`의 output type별 line, heading과 estimated token 기준으로 preview를 비교한다.
- Profile의 구조화된 `size_budget`이 더 엄격하면 profile 값을 우선 적용한다.
- 목표 안이면 info, 목표 초과부터 error 기준 이하면 warning, error 기준 초과면 error로 기록한다.
- Skill body inline은 line/token 수와 관계없이 error로 기록한다.
- Skill 본문, 중복 설명과 background를 분리 후보로 제안한다.
- 필수 규칙을 자르거나 warning 없이 초과 output을 반환하지 않는다.

실제 token 계산기는 아직 없으므로 manual dry-run은 정책 문서의 보수적 문자 기반 추정값과 측정 근거를 함께 기록한다.

## 현재 범위

Check code enum, JSON schema, validator class와 report renderer는 구현하지 않는다. 이 문서는 report에 필요한 의미와 판정 기준만 정의한다.
