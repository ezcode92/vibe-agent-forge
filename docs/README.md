# docs

프로젝트의 아키텍처, 용어, 의사결정과 설계 원칙을 기록합니다. 초기 단계에서는 구현 명세보다 책임 경계와 구성 요소 간 관계를 우선해 문서화합니다.

## Web UI 설계

Web UI의 방향, 화면 구조, profile builder, compatibility/conflict, preview/export, project binding, 개념 데이터 모델과 MVP 범위는 `web-ui-*.md` 및 관련 flow 문서에서 설명합니다. 현재는 텍스트 기반 설계만 존재하며 실제 Web UI, API, database, generator와 installer 구현은 없습니다.

## MVP Generator 설계

Generator의 입력·출력 계약, 처리 pipeline, fragment merge, skill 선택, validation report와 MVP 범위는 `generator-*.md`, `fragment-merge-strategy.md`, `skill-selection-strategy.md`에서 설명합니다. 현재는 preview-only 설계 단계이며 generator, validator, CLI, API와 file writer 구현은 없습니다.

## Manual Dry-run

Generator 구현 전 수동 조합 검증 절차는 `manual-dry-run-guide.md`에서 설명하며, Codex 기준 dry-run 산출물은 `examples/codex/` 아래에 둡니다. 모든 산출물은 preview example이며 실제 agent 설정이나 export 결과가 아닙니다.

Spring–Modular Monolith 조합 책임은 `spring-modular-monolith-bridge-guide.md`, agent preview의 정량 크기 기준은 `output-size-budget.md`에서 설명합니다.
