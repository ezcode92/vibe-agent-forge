# Codex Adapter

## 목적

에이전트 중립적인 구성을 Codex의 project `AGENTS.md` preview와 skill 참조 규칙으로 표현하는 변환 경계를 정의합니다.

## 계약 문서

- `adapter.md`: Codex adapter 요약 계약
- `docs/codex-adapter-contract.md`: 공식 입력·출력 계약
- `docs/codex-output-mapping.md`: Section mapping 규칙
- `docs/codex-adapter-validation.md`: 검증 severity와 readiness 규칙

## 현재 범위

현재 상태는 `mvp-contract`입니다. Preview 계약만 확정했으며 변환 코드, generator, validator, 실제 설정 파일과 hook은 추가하지 않습니다.
