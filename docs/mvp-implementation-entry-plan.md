# MVP 구현 진입 계획

## 목적

Phase 11에서 Codex 전용 read-only generator/validator를 구현하기 위한 범위와 진입 조건을 확정한다. 이 문서는 구현 계획이며 code, build 설정, CLI와 file writer를 생성하지 않는다.

## 구현 대상

- Registry catalog YAML 5종과 profile manifest 6종 load·parse
- Profile, fragment, skill, adapter와 template path/ID 참조 해석
- Required dependency, conflict, exactly-one variant와 compatibility 검증
- Codex `mvp-contract`와 template 검증
- Catalog lifecycle과 dry-run coverage를 이용한 `reviewed-for-mvp`/`ready-candidate` 판정
- Error/warning/info와 `ready`/`ready-with-warnings`/`blocked`를 가진 구조화 report
- Preview context, merge trace, skill selection과 export plan의 논리 planning

## 제외 대상

- Root 또는 project `AGENTS.md` write, overwrite, backup과 rollback
- Artifact file materialization과 installer
- CLI, API endpoint, Web UI와 database schema
- Claude/Gemini adapter 실행
- MSA pending compatibility 해소 또는 수용
- AI 기반 semantic merge, 자동 conflict 수정과 자동 요약
- Commit, push와 publisher 호출

## Read-only 책임

MVP는 repository source를 읽고 결정적 논리 결과를 반환한다. Source catalog, profile, fragment, skill, adapter와 template을 수정하지 않으며 target project file도 읽거나 쓰지 않는다. `dry-run`과 `export-plan` 모두 `writePerformed: false`다.

## Codex-only 원칙

`adapterId: codex`와 `mvp-contract`만 허용한다. Claude/Gemini는 catalog에 존재해도 `draft`이므로 target error다. Codex dry-run coverage를 다른 adapter readiness 근거로 재사용하지 않는다.

## Catalog Readiness 반영

- 정확한 Codex `ready` dry-run coverage: `reviewed-for-mvp`, info
- 구조 검증은 통과했지만 coverage 없음: `ready-candidate`, warning
- Selected pending/unregistered compatibility: error, blocked
- Unselected pending compatibility: ignored
- Catalog YAML status는 자동 변경하지 않음

## Phase 11 진입 조건

1. Phase 10-2 decision 6개와 Phase 10-3 readiness decision이 `decided`다.
2. Module boundary, file structure와 acceptance criteria가 review됐다.
3. 구현 언어와 package manager 초기화가 별도 구현 요청에서 승인된다.
4. 구현 변경이 보호 대상과 문서 자산을 수정하지 않는 검증 방법이 준비된다.
5. 첫 increment가 filesystem output 없이 독립적으로 test 가능하다.

## 첫 번째 최소 기능

첫 increment는 registry YAML 5종과 profile YAML 6종을 read-only로 load·parse하고 ID index, 필수 field와 source path를 검증한 구조화 report를 반환한다. Preview Markdown, export plan file, CLI와 target project binding은 포함하지 않는다.

이 increment의 성공 기준은 정상 repository source에 error가 없고, 존재하지 않는 selected profile과 missing source path를 error/blocked로 일관되게 보고하는 것이다.
