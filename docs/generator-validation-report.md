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
| Unresolved optional item | Warning 또는 Error | Required variant는 해소, optional 추천은 결정 기록 | Required면 blocked, 선택 추천이면 warning |
| Compatibility violation | Error | Incompatible relation 없음 | Conflict 해결 전 blocked |
| Missing bridge | Error 또는 Warning | 존재하는 required bridge 선택 | Required면 error, bridge 자체 pending이면 warning |
| Unsupported adapter output | Error 또는 Warning | 필수 output 지원 | 필수면 blocked, optional이면 warning |
| Output length warning | Warning | Budget 안이거나 수동 검토 근거 있음 | 절단 없이 warning/blocked 판단 |

## 추가 권장 검증

- Profile count와 resolved 구성 수의 일치
- Profile path와 catalog ID mapping
- Bridge dependency completeness
- Override scope와 근거
- 미치환 필수 template placeholder
- Skill trigger와 lazy loading 상태
- Merge policy와 catalog numeric priority 일치
- 기존 git-auto policy를 약화하는 output 포함 여부

## Generator 실패 조건

- Registry 또는 profile의 필수 YAML을 parse할 수 없다.
- Selected profile/adapter 또는 필수 path가 없다.
- Duplicate ID 때문에 참조가 모호하다.
- Required dependency, variant 또는 bridge가 미해결이다.
- Incompatible fragment가 동시에 선택됐다.
- Semantic conflict를 priority와 근거로 해결할 수 없다.
- Adapter의 필수 preview target/template이 없다.
- Validation report 자체를 완성할 수 없다.

실패 시에도 확인된 error와 not-run 단계는 반환한다. Partial preview를 완성 결과처럼 표시하지 않는다.

## Preview 가능 조건

- Error가 0개다.
- Required reference, dependency, bridge와 variant가 해소됐다.
- Adapter template 및 필수 metadata가 존재한다.
- Warning이 source, 영향과 수동 결정 상태를 가진다.
- File write가 수행되지 않는다.

Pending 또는 unregistered 관계가 있으면 정책상 허용된 수동 수용 기록이 있을 때만 `ready-with-warnings`가 가능하다.

## Output Length 처리

- 정량 budget이 있으면 preview 길이와 비교한다.
- 현재처럼 budget이 문장 정책이면 정량 성공을 선언하지 않고 warning/info로 남긴다.
- Skill 본문, 중복 설명과 background를 분리 후보로 제안한다.
- 필수 규칙을 자르거나 warning 없이 초과 output을 반환하지 않는다.

## 현재 범위

Check code enum, JSON schema, validator class와 report renderer는 구현하지 않는다. 이 문서는 report에 필요한 의미와 판정 기준만 정의한다.
