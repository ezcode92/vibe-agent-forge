# docs

프로젝트의 아키텍처, 용어, 의사결정과 설계 원칙을 기록합니다. 초기 단계에서는 구현 명세보다 책임 경계와 구성 요소 간 관계를 우선해 문서화합니다.

## 현재 문서 자산

- Fragment: `core/`, `stacks/`와 관련 `*-fragment-guide.md`
- Skill: `skills/`, `common-skill-guide.md`, `stack-specific-skill-guide.md`, `frontend-mobile-skill-guide.md`
- Profile: `profiles/`, `profile-spec.md`, `profile-manifest-guide.md`
- Adapter: `adapters/`, `adapter-guide.md`; Codex는 `mvp-contract`, Claude/Gemini는 `draft`
- Registry: `registry/`, `registry-catalog-guide.md`
- 상태 정책: `lifecycle-status-policy.md`

현재 Phase 0~10-2의 문서·설계 gate는 완료됐다. Phase 10-2에서 Phase 8의 generator 구현 전 결정사항 6개를 문서 계약으로 확정했지만 실제 generator, validator, CLI, Web UI 또는 installer 구현은 시작하지 않았다.

## Web UI 설계

Web UI의 방향, 화면 구조, profile builder, compatibility/conflict, preview/export, project binding, 개념 데이터 모델과 MVP 범위는 `web-ui-*.md` 및 관련 flow 문서에서 설명합니다. 현재는 텍스트 기반 설계만 존재하며 실제 Web UI, API, database, generator와 installer 구현은 없습니다.

## MVP Generator 설계

Generator의 입력·출력 계약, 처리 pipeline, fragment merge, skill 선택, validation report와 MVP 범위는 `generator-*.md`, `fragment-merge-strategy.md`, `skill-selection-strategy.md`에서 설명합니다. 현재는 preview-only 설계 단계이며 generator, validator, CLI, API와 file writer 구현은 없습니다.

실행 형태, validator와 schema 범위, project binding, output write 승인과 dry-run/export 경계는 `generator-pre-implementation-decisions.md`에서 모두 `decided`로 확정했습니다. MVP는 Codex 전용 read-only preview/export-plan 계약이며 실제 write는 지원하지 않습니다.

## Manual Dry-run

Generator 구현 전 수동 조합 검증 절차는 `manual-dry-run-guide.md`에서 설명하며, Codex 기준 `backend-kotlin-spring-rdb`, `python-cli-automation`, `frontend-react`, `flutter-app`, `fullstack-spring-react` dry-run 산출물은 `examples/codex/` 아래에 둡니다. 모든 산출물은 preview example이며 실제 agent 설정이나 export 결과가 아닙니다. Fullstack은 Kotlin variant를 `examples/codex/fullstack-spring-react/`, Java variant를 `examples/codex/fullstack-spring-react-java/`에서 각각 `ready`로 검증했습니다.

Spring–Modular Monolith 조합 책임은 `spring-modular-monolith-bridge-guide.md`, agent preview의 정량 크기 기준은 `output-size-budget.md`에서 설명합니다.

Python CLI와 automation의 command, side effect, retry 및 workflow 경계와 fragment 선택 기준은 `cli-automation-architecture-guide.md`에서 설명합니다. 이는 architecture 설계 문서이며 실제 CLI나 generator 구현이 아닙니다.

## Codex Adapter 계약

Codex adapter의 공식 MVP 계약과 template 상태는 `codex-adapter-contract.md`, section별 source·placeholder 규칙은 `codex-output-mapping.md`, template 문구 정합성을 포함한 severity와 readiness 판정은 `codex-adapter-validation.md`에서 설명합니다. `mvp-contract`는 preview 계약의 확정을 뜻하며 generator, validator, CLI, file writer와 실제 Codex 설정 export는 아직 구현되지 않았습니다.

## Compatibility Pending

Compatibility matrix의 `spring-msa`, `restful-api-msa`는 `compatibility-pending-items.md`에서 보류 이유, bridge 판단 기준과 현재 MVP 영향을 설명합니다. 두 항목은 지원 완료로 해석하지 않습니다.
