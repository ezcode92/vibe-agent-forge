# Generator 구현 전 결정사항

## 목적

Phase 8에서 남긴 generator 구현 전 decision gate를 확정한다. 이 문서는 MVP 구현자가 실행 형태, 검증 범위와 side effect 경계를 추가로 추정하지 않도록 계약을 고정하며 실제 generator, validator, CLI 또는 file writer 구현을 포함하지 않는다.

## 결정 상태 체계

이 문서의 decision status는 `decided`, `deferred`, `out-of-scope`를 사용한다. 이는 자산 lifecycle의 `draft`, `mvp-contract`, `ready`와 별개다. 이번 Phase 10-2의 6개 필수 decision은 모두 `decided`다.

## GEN-DEC-001 Generator 실행 형태

- 결정 ID: `GEN-DEC-001`
- 결정 상태: `decided`
- 최종 결정: MVP generator는 하나의 구조화된 요청을 받아 하나의 결정적 결과 묶음을 반환하는 단일 실행, local, read-only 변환 경계로 구현한다. CLI, API endpoint와 Web UI는 실행 진입점에 포함하지 않는다.
- 선택 이유: 현재 source가 repository 문서 자산이고 Codex dry-run이 동일 입력의 재현 가능한 preview를 검증했으므로 side effect 없는 변환 경계가 가장 작은 구현 범위다.
- MVP 포함 범위: Registry/profile/Codex adapter/template load, 참조 해석, compatibility 검증, merge trace, skill selection, preview와 validation report 구성.
- MVP 제외 범위: 장기 실행 service, CLI command, API server, Web UI, background job, installer와 Git operation.
- 후속 확장 후보: 확정된 변환 경계를 호출하는 CLI 또는 Web UI adapter. Core 계약을 바꾸지 않는 별도 승인 사항이다.

## GEN-DEC-002 Validator 범위

- 결정 ID: `GEN-DEC-002`
- 결정 상태: `decided`
- 최종 결정: MVP validator는 YAML parse와 구조, ID 유일성, path, dependency/conflict, profile count, variant, compatibility/required bridge, Codex adapter/template, placeholder, output budget, protected-file invariant를 검증한다. 자연어 규칙의 의미 동등성이나 고급 semantic merge를 자동 판정하지 않는다.
- 선택 이유: Manual dry-run에서 객관적으로 반복 검증한 항목은 자동화 경계로 고정할 수 있지만 자연어 의미 판단은 결정적 결과와 오류 근거를 보장하기 어렵다.
- MVP 포함 범위: 구조·참조·조합·출력 계약의 결정적 검증과 error/warning/info report.
- MVP 제외 범위: AI 기반 의미 추론, 자동 conflict 수정, 자동 요약, source 내용의 품질 승인과 agent runtime 검증.
- 후속 확장 후보: Provenance를 보존하는 semantic rule model과 reviewer 승인 기반 진단.

## GEN-DEC-003 Schema Validation 방식

- 결정 ID: `GEN-DEC-003`
- 결정 상태: `decided`
- 최종 결정: MVP는 현재 YAML의 `version: 1`과 기존 문서 계약을 기준으로 root type, 필수 field, field type과 허용 값부터 검증한 뒤 cross-catalog reference를 별도 단계에서 검증한다. 초기 MVP에는 별도 JSON Schema 파일이나 schema migration engine을 도입하지 않는다.
- 선택 이유: 현재 catalog/profile 형식을 유지하면서 구조 오류와 관계 오류를 분리할 수 있고 새로운 schema 기술이나 migration 범위를 추가하지 않는다.
- MVP 포함 범위: Version 확인, mapping/list 형태, 필수 field/type, status·relation 등 문서에 정의된 값, cross-reference 검증.
- MVP 제외 범위: 자동 migration, 여러 schema version 동시 지원, 원격 schema registry와 code generation.
- 후속 확장 후보: `version` 변경이 실제로 필요해질 때 declarative schema와 migration policy 도입.

## GEN-DEC-004 Project Binding 방식

- 결정 ID: `GEN-DEC-004`
- 결정 상태: `decided`
- 최종 결정: MVP는 요청에 명시적으로 전달된 project metadata만 사용한다. Repository path는 provenance용 선택 metadata일 수 있지만 existing project file, Git 상태, build 설정과 secret을 자동 탐색하거나 추론하지 않는다.
- 선택 이유: Dry-run의 placeholder 정책을 유지하고 repository별 부작용, local secret 노출과 비결정적 환경 의존성을 배제한다.
- MVP 포함 범위: Project name/type, 확인된 stack, validation commands, scope boundary와 선택적 repository 식별 정보.
- MVP 제외 범위: Repository scan, existing `AGENTS.md` read/diff, build tool 탐지, secret/local config 읽기와 remote repository 연결.
- 후속 확장 후보: 사용자가 명시적으로 승인한 read-only project inspector와 provenance contract.

## GEN-DEC-005 Output Write 승인 시점

- 결정 ID: `GEN-DEC-005`
- 결정 상태: `decided`
- 최종 결정: 초기 MVP는 filesystem write를 지원하지 않는다. `dry-run`과 `export-plan` 모두 `writePerformed: false`이며 실제 write는 별도 export 계약, 보호 파일 정책, overwrite/backup/rollback과 사용자 승인 방식이 확정된 이후에만 새 phase로 검토한다.
- 선택 이유: 현재 검증 근거는 preview이고 root `AGENTS.md`, hook와 사용자 파일을 안전하게 변경하는 계약은 범위 밖이다.
- MVP 포함 범위: 논리 artifact와 선택적 `export-plan.md`에 대상·차단 사유·수동 후속 조치를 기록.
- MVP 제외 범위: Directory 생성, 파일 저장, overwrite, backup, permission 변경, commit, push와 installer.
- 후속 확장 후보: 명시적 승인과 protected-file 검증을 전제로 하는 별도 export capability.

## GEN-DEC-006 Dry-run과 실제 Export의 차이

- 결정 ID: `GEN-DEC-006`
- 결정 상태: `decided`
- 최종 결정: MVP request mode는 `dry-run` 또는 `export-plan`이다. `dry-run`은 preview와 report만 구성하고, `export-plan`은 같은 검증 결과에 예정 대상 path, 충돌·보호 상태와 수동 적용 조건을 추가한다. 실제 export는 파일을 쓰는 별도 미래 capability이며 MVP mode가 아니다.
- 선택 이유: 검증 결과와 side effect를 분리하면서 향후 export 설계에 필요한 계획 정보만 안전하게 검토할 수 있다.
- MVP 포함 범위: `AGENTS.preview.md`, `merge-trace.md`, `skill-selection.md`, `validation-report.md`; `export-plan` mode에서만 `export-plan.md` 추가.
- MVP 제외 범위: 실제 `AGENTS.md` 생성·수정, preview를 실제 설정으로 표시, 자동 적용과 설치 완료 판정.
- 후속 확장 후보: Export plan 승인 결과를 입력으로 받는 독립 writer와 rollback 계약.

## 함께 확정된 공통 정책

- MVP adapter ID는 `codex`만 허용한다. Claude/Gemini는 `draft` 후속 범위다.
- Fullstack `backend_language`는 Java 또는 Kotlin 중 정확히 하나를 선택해야 하며 미선택·복수 선택은 error다.
- `pending` compatibility가 resolved 입력에 포함되면 초기 MVP에서는 수용 가능한 warning으로 낮추지 않고 error로 차단한다. `spring-msa`, `restful-api-msa`는 해결하지 않는다.
- Profile path와 catalog ID는 현재 구조를 유지하고 validator가 양방향 일치를 확인한다. ID-only manifest 전환은 schema version 변경 후보로 미룬다.
- Merge는 catalog priority, merge policy와 명시적 provenance만 사용한다. 의미 충돌을 AI가 임의 해결하지 않는다.
- 결정적 artifact는 UTF-8, LF, template section 순서, merge priority와 안정된 ID 순서를 사용한다. 실행 시각 등 가변 metadata는 결정적 content 비교에서 제외한다.

## GEN-DEC-007 Catalog Status 해석

- 결정 ID: `GEN-DEC-007`
- 결정 상태: `decided`
- 최종 결정: Fragment, skill과 profile의 `draft`는 단독 warning/error가 아니다. 정확한 Codex `ready` dry-run coverage가 있으면 `reviewed-for-mvp` info, 구조적으로 유효하지만 coverage가 없으면 `ready-candidate` warning으로 판정한다. 두 판정은 catalog status를 변경하지 않는다.
- 선택 이유: 현재 6개 dry-run은 draft 자산 조합을 검증했지만 개별 catalog lifecycle 승격을 승인한 것은 아니다. 조합 검증 근거를 활용하면서 lifecycle과 실행 readiness를 분리해야 한다.
- MVP 포함 범위: Selected profile·variant·resolved source와 dry-run coverage 대조, 파생 판정과 severity report.
- MVP 제외 범위: Registry YAML 자동 수정, catalog status 자동 승격과 implementation readiness 선언.
- 후속 확장 후보: 자산별 review와 승인 근거를 갖춘 별도 catalog status 승격 작업.

## GEN-DEC-008 Selected/Unselected Pending 처리

- 결정 ID: `GEN-DEC-008`
- 결정 상태: `decided`
- 최종 결정: Resolved 선택 조합에 포함된 pending 또는 unregistered compatibility는 error/blocked다. 선택되지 않은 pending entry는 ignored이며 현재 실행 readiness를 낮추지 않는다.
- 선택 이유: Catalog 전체의 미지원 관계가 무관한 지원 조합을 차단해서는 안 되지만, 실제 선택 조합의 의미 누락은 warning 수용으로 우회할 수 없다.
- MVP 포함 범위: Resolved relation만 validation 대상으로 평가하고 selected pending을 차단.
- MVP 제외 범위: `spring-msa`, `restful-api-msa` 해소, 가상 bridge 생성과 사용자 수용에 의한 severity 완화.
- 후속 확장 후보: MSA profile과 대표 dry-run이 추가된 뒤 bridge 또는 supported 관계 설계.
