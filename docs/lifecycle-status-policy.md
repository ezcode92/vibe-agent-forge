# Lifecycle 및 Readiness 상태 정책

## 목적

구성 자산의 수명 주기와 dry-run 검증 결과를 같은 의미로 오해하지 않도록 상태별 기준을 정의한다. 현재는 자동 validator가 없으므로 상태 판정은 문서에 기록된 수동 검증과 review 근거를 따른다.

## 상태 의미

| 상태 | 의미 |
| --- | --- |
| `draft` | 구조와 내용이 존재하지만 계약 안정성, 대표 조합 또는 의미 동등성 검토가 끝나지 않은 설계 자산 |
| `mvp-contract` | MVP 입력·출력·mapping·검증·미지원 범위가 구현자가 추가 정책을 추정하지 않아도 될 수준으로 확정된 계약 |
| `ready` | 대상 검증의 모든 필수 check가 통과하고 error, warning, 미실행 필수 check와 unresolved 필수 결정이 없는 상태 |
| `ready-with-warnings` | Error는 없고 필수 check는 통과했지만 영향과 수동 후속 조치가 명시된 warning이 남은 상태 |
| `blocked` | 필수 source·dependency·bridge·variant·section 또는 계약 조건이 해소되지 않아 결과를 준비할 수 없는 상태 |
| `pending` | 관계나 책임이 아직 설계·지원되지 않아 지원 완료로 판단할 수 없는 보류 상태 |

## Decision 상태와 구분

Decision 문서는 `decided`, `deferred`, `out-of-scope`를 사용한다.

- `decided`: 현재 범위에서 선택과 근거가 확정됐다.
- `deferred`: 결정 시점과 진입 조건을 후속 단계로 미뤘다.
- `out-of-scope`: 현재 decision gate가 다루지 않는 항목이다.

Decision 상태는 문서 자산의 lifecycle이나 dry-run readiness를 나타내지 않는다. 예를 들어 generator decision 6개가 `decided`여도 generator 구현은 존재하지 않으며 profile catalog의 `draft` 상태도 자동 변경되지 않는다.

## 자산별 해석

- Fragment: 처음에는 `draft`다. 책임 경계, dependency/conflict, registry path와 대표 profile 조합이 검토되면 `ready` 승격 후보가 된다.
- Skill: 처음에는 `draft`다. Trigger, 절차, 완료 기준, dependency와 profile routing이 검토되면 `ready` 승격 후보가 된다.
- Profile: 처음에는 `draft`다. 모든 참조, variant, bridge, constraint, count와 대표 adapter dry-run이 검증되면 `ready` 승격 후보가 된다.
- Adapter: 개념 mapping 단계는 `draft`다. 입력·출력·mapping·validation·unsupported policy가 확정되면 `mvp-contract`로 승격할 수 있다. 이는 adapter code가 구현됐다는 뜻이 아니다.
- Dry-run: validation report의 error, warning과 필수 check 결과에 따라 `ready`, `ready-with-warnings` 또는 `blocked`로 판정한다.
- Compatibility: 관계와 필요한 bridge가 확정되지 않았으면 `pending`이다. 존재하지 않는 path를 만들거나 supported로 추정하지 않는다.

## 승격 기준

### Draft에서 Ready

Fragment, skill 또는 profile은 다음 조건을 모두 충족해야 한다.

1. 필수 field와 source path가 존재한다.
2. ID, dependency, conflict, profile reference와 count가 유효하다.
3. 책임 경계가 인접 자산과 중복되거나 충돌하지 않는다.
4. 관련 대표 조합의 수동 검증 근거가 있다.
5. Blocking pending과 미해소 필수 결정이 없다.
6. Review 결과와 승격 근거가 문서에 남는다.

### Draft에서 MVP Contract

Adapter 계약은 다음 조건을 모두 충족해야 한다.

1. 입력과 논리 출력이 정의된다.
2. Profile, fragment, skill과 template mapping이 정의된다.
3. Error, warning, readiness와 unsupported feature 정책이 정의된다.
4. 보호 대상과 write 금지 범위가 명시된다.
5. 대표 dry-run에서 계약을 수동 적용할 수 있다.

## Warning 0과 Ready의 차이

Warning이 0이라는 사실만으로 `ready`가 되지 않는다. 필수 check가 실행되지 않았거나 필수 source, variant, dependency 또는 결정이 누락되면 warning이 없어도 `blocked` 또는 미판정 상태다. `ready`는 warning 0과 함께 모든 필수 check 통과 및 unresolved 필수 조건 부재를 요구한다.

## Pending Compatibility 처리

- Pending relation은 지원 가능한 조합으로 추천하지 않는다.
- 필요한 bridge가 없으면 가상의 path나 catalog entry를 만들지 않는다.
- 선택 profile이 pending relation을 포함하면 영향, 수용 여부와 후속 조치를 validation report에 기록한다.
- 보안, 데이터 무결성 또는 필수 의미 보존 문제가 있으면 warning 수용으로 우회하지 않고 `blocked`로 처리한다.
- Bridge 책임, 적용 조건과 검증 기준이 합의된 뒤 별도 변경으로 registry 상태를 갱신한다.
- 초기 Codex MVP generator는 pending/unregistered relation을 error로 차단한다. 향후 다른 정책이 승인되기 전에는 사용자 수용만으로 `ready-with-warnings`로 낮추지 않는다.

## 현재 적용 범위

현재 catalog status는 이 정책을 문서화했다는 이유만으로 변경하지 않는다. 자동 schema validator, dependency resolver와 generator가 없으므로 YAML parse, path·ID·dependency 대조와 manual dry-run 기록을 수동 검증 근거로 사용한다.
