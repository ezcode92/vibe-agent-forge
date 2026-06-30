# MVP Module Boundary

## 목적

Phase 11 구현에서 책임이 섞이지 않도록 논리 module의 입력, 출력과 금지 책임을 정의한다. 실제 package, class, function 이름은 구현 단계에서 언어 관례에 맞게 정하며 이 문서는 Web UI, API와 database boundary를 다루지 않는다.

## 공통 원칙

- Loader는 source를 읽고 구조를 전달하며 조합 정책을 결정하지 않는다.
- Resolver는 catalog와 manifest 참조를 연결하며 누락을 추정하지 않는다.
- Checker/evaluator는 진단을 만들며 source를 수정하지 않는다.
- Builder/planner는 검증된 context를 논리 output으로 구성하며 filesystem에 쓰지 않는다.
- 모든 module은 source provenance와 deterministic ordering을 보존한다.

## Module 책임

| Module | 입력 | 출력 | 책임 | 하지 말아야 할 일 |
| --- | --- | --- | --- | --- |
| Registry loader | Registry root와 catalog 경로 | Parsed catalog 집합과 source provenance | YAML parse, root/field 구조와 version 전달 | Profile 선택, dependency 해소, source 수정 |
| Profile loader | Selected profile ID, profile catalog | Parsed manifest와 catalog entry | ID/path 일치, manifest load와 기본 구조 전달 | Variant 기본값 추정, compatibility 판정 |
| Adapter loader | Adapter ID, adapter catalog | Adapter contract와 template reference | Codex status, contract와 template 존재 확인 | Claude/Gemini fallback, output 생성 |
| Path resolver | Parsed catalog/profile references | Canonical ID/path mapping과 누락 진단 | Repository-relative path 정규화와 존재 확인 | 유사 path 대체, target project scan |
| Compatibility checker | Resolved fragment 집합과 matrix | Relation, required bridge와 conflict 진단 | Selected relation만 평가하고 pending/incompatible 분류 | Unselected pending으로 실행 차단, bridge 생성 |
| Variant resolver | Profile variants와 명시 선택 | 정확히 하나의 resolved option 또는 error | Exactly-one과 option 묶음 검증 | 기본 language 선택, 복수 option 병합 |
| Readiness evaluator | Selected 자산, dry-run coverage와 lifecycle | `reviewed-for-mvp`/`ready-candidate`와 severity | Catalog lifecycle과 실행 readiness 분리 | Registry status 변경, implementation readiness 선언 |
| Preview context builder | 검증된 fragments, skills, metadata와 Codex mapping | Section별 source context | Template section과 provenance에 맞는 논리 context 구성 | Markdown file write, AI semantic conflict 해결 |
| Output planner | Mode와 검증된 context | Logical artifact set과 선택적 export plan | Artifact 대상, 순서, 보호 상태와 `writePerformed: false` 기록 | Directory/file 생성, overwrite와 installer 수행 |
| Validation report builder | 모든 단계 진단과 not-run 정보 | Canonical structured report와 Markdown view model | Severity 집계, readiness와 deterministic ordering | Error 완화, source 수정, renderer-specific 정책 소유 |

## Phase 11-1 구현 구분

| Module | Phase 11-1 상태 | 범위 |
| --- | --- | --- |
| Registry loader | 포함 | Catalog 5종 load·parse와 기본 구조 진단 |
| Profile loader | 포함 | Manifest 6종 load·parse와 catalog ID/path 대조 |
| Path resolver | 포함 | Repository-relative source path 존재 확인 |
| Validation report builder | 포함 | Machine-readable report 최소 field, severity 집계와 blocked 판정 |
| Adapter loader | 후속 | Codex contract/template validation increment에서 구현 |
| Compatibility checker | 후속 | Selected/unselected relation validation increment에서 구현 |
| Variant resolver | 후속 | Fullstack exactly-one validation increment에서 구현 |
| Readiness evaluator | 후속 | Dry-run coverage와 catalog status evaluation increment에서 구현 |
| Preview context builder | 후속 | Loader/validator 결과 안정화 뒤 구현 |
| Output planner | 후속 | Logical preview/export-plan 단계에서 구현 |

Phase 11-1은 후속 module의 빈 interface, placeholder class 또는 future package를 미리 만들지 않는다.

## Phase 11-1 제외 Boundary

- Adapter rendering과 Markdown preview materialization
- Output/export writer와 write approval
- CLI entrypoint와 command routing
- Web UI, API endpoint와 database
- Installer, Git/publisher와 protected-file helper

## 의존 방향

Loaders가 source model을 제공하고 resolver/checker가 validated context를 만든다. Readiness evaluator와 preview context builder는 validated context만 소비한다. Output planner와 validation report builder는 최종 논리 결과를 구성한다. 뒤 단계는 앞 단계의 source를 변경하거나 loader에 정책 결정을 역으로 요구하지 않는다.

## 횡단 책임

- Diagnostic identity와 source provenance
- UTF-8/LF 및 안정된 ID ordering
- Protected-file invariant
- Error 이후 `not-run` 전파
- Test fixture와 production source 경로의 명시적 분리

횡단 책임은 공통 계약으로 공유하되 모든 module이 별도 filesystem writer나 Git helper를 갖지 않는다.
