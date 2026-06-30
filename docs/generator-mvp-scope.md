# Generator MVP Scope

## 목적

첫 generator 범위를 repository source의 읽기·검증과 Codex adapter template 기반 preview/export plan 구성으로 한정한다. 실제 파일 생성과 설치 없이 입력 계약, merge·selection과 report가 일관되는지를 확인한다.

## MVP 포함 범위

### Profile Load

- Selected profile ID 조회
- Profile catalog와 manifest ID/path 대조
- Variant, pending, output과 constraint 읽기

### Registry Load

- Fragment, skill, profile, adapter와 compatibility catalog parse
- ID index와 version metadata 구성 개념
- Required field와 중복 ID 검증
- 선택 자산의 lifecycle과 `reviewed-for-mvp`/`ready-candidate` coverage 판정

### Path Validation

- Pending 제외 source와 template path 존재 확인
- Profile path와 catalog path mapping
- Missing path의 severity 및 source report

### Compatibility Check

- Source/target relation 조회
- Required bridge와 `conflicts_with` 확인
- Pending, unregistered와 incompatible 구분
- 선택되지 않은 pending relation은 실행 readiness에서 제외

### Merge Order Calculation

- Category별 output section 구성
- Catalog priority 및 merge policy 적용
- Deduplication, override와 semantic conflict 진단

### Adapter Template 기반 Preview

- Codex adapter와 template 선택
- Project metadata와 selected source의 논리 mapping
- 미치환 placeholder 및 unsupported feature 표시

### Read-only Generation Planning

- `dry-run`과 `export-plan` mode 구분
- `AGENTS.preview.md`, merge trace, skill selection과 validation report 계약
- `export-plan` mode의 대상 path, 보호 상태와 수동 후속 조치
- 모든 mode에서 `writePerformed: false`

### Validation Report

- Error/warning/info 집계
- Preview readiness와 not-run 단계
- Included source, conflict와 checklist 반환

## MVP 제외 범위

- 실제 agent 설정과 skill file write
- Existing file read, diff, overwrite와 backup
- Installer, package와 archive 생성
- Web UI 구현
- Account, login과 권한 관리
- Remote repository 연결
- Background sync와 catalog update
- 자동 commit, push와 publisher 호출
- 실제 generator 및 validator code
- CLI, API endpoint와 server
- Recommendation model과 conflict 자동 수정
- Claude/Gemini adapter 구현과 preview
- MSA pending compatibility 해소 또는 수용
- 고급 AI semantic merge와 자동 의미 충돌 해결
- 실제 root `AGENTS.md` 자동 write 또는 overwrite

## Codex 우선 검증

1. `backend-kotlin-spring-rdb` 또는 단순 profile을 Codex target 입력 사례로 수동 검토한다.
2. `templates/codex/AGENTS.md.template`의 section mapping을 확인한다.
3. Core/project scope, merge priority, selected skill와 validation checklist를 검증한다.
4. Git-auto hook과 직접 commit·push 금지 정책이 unsupported/warning에서 누락되지 않는지 확인한다.
5. `writePerformed: false`와 preview-only 상태를 확인한다.
6. Claude/Gemini와 MSA는 MVP 후속 범위로 분리한다.

Codex 우선은 다른 adapter의 출력 형식이나 capability를 Codex와 같게 만드는 전략이 아니다.

## MVP Status 허용 정책

- Adapter: `mvp-contract`인 Codex만 허용한다. `draft`인 Claude/Gemini는 target error다.
- Fragment·skill·profile: `draft` status 자체는 허용한다. 정확한 Codex `ready` dry-run coverage가 있으면 `reviewed-for-mvp` info, 없으면 `ready-candidate` warning으로 판정한다.
- Draft 자산의 path, dependency, bridge, conflict와 variant 오류는 별도 error이며 draft라는 이유로 완화하지 않는다.
- Compatibility: Selected `pending` 또는 unregistered relation은 error/blocked다. Unselected pending relation은 현재 실행을 막지 않는다.
- Catalog YAML status는 generator 실행이나 dry-run 결과로 자동 변경하지 않는다.

## MVP 성공 기준

- 동일 입력과 source version이 동일한 논리 preview 및 check 결과를 만든다.
- Missing path, duplicate ID, conflict와 missing bridge가 preview 전에 탐지된다.
- Profile skill과 lazy loading 상태가 구분된다.
- Warning이 있는 preview와 blocking 실패가 명확히 다르다.
- Codex template와 unsupported feature를 추적할 수 있다.
- 어떤 경우에도 repository file write와 Git operation을 수행하지 않는다.

## Phase 10-2 확정 사항

- 실행 형태, validator, schema, project binding, output write와 dry-run/export 경계는 `generator-pre-implementation-decisions.md`에서 `decided`로 확정했다.
- Profile path와 catalog ID의 현재 병행 구조를 유지하고 validator가 일치를 검사한다.
- Pending compatibility는 초기 MVP에서 error로 차단한다.
- Deterministic output은 UTF-8, LF, template section 순서, merge priority와 안정된 ID 순서를 따른다.
- Semantic merge의 고급 자동 판단, adapter별 capability 확장과 ID-only schema migration은 후속 범위다.

## Phase 10-3 확정 사항

- Catalog lifecycle과 generator readiness를 분리한다.
- Codex dry-run coverage는 `reviewed-for-mvp` 파생 판정에 사용하되 catalog status를 승격하지 않는다.
- Coverage가 없는 유효 draft 조합은 `ready-candidate` warning으로 검토할 수 있다.
- Selected pending compatibility만 차단하고 unselected pending은 실행 판정에서 제외한다.

## Phase 10-4 구현 진입 범위

- Phase 11의 첫 범위는 registry/profile load·parse, ID/path resolve, dependency·variant·compatibility validation과 canonical report planning이다.
- Preview context와 export plan은 앞 단계의 structured result가 안정된 뒤 후속 increment로 구현한다.
- Initial MVP는 logical content만 반환하고 Markdown과 artifact file을 materialize하지 않는다.
- 실제 root `AGENTS.md`, target project와 repository source write는 구현하지 않는다.
- 권장 module과 file structure 및 완료 기준은 `mvp-module-boundary.md`, `mvp-file-structure-plan.md`, `mvp-acceptance-criteria.md`를 따른다.
- Claude/Gemini, MSA pending 해소, CLI, Web UI, installer와 actual export는 Phase 11 진입 범위 밖이다.

## 현재 범위

이 문서는 MVP의 설계 경계와 성공 기준만 정의한다. Generator, validator, CLI, API, Web UI와 file writer implementation은 만들지 않는다.
