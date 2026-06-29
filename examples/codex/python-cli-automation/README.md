# Python CLI Automation Codex Dry-run

> 이 디렉터리는 수동 dry-run을 위한 preview example입니다. 실제 Codex 설정이나 export 결과가 아니며 root `AGENTS.md`, 전역 `~/.codex/AGENTS.md`와 `.codex/hooks.json`을 생성하거나 변경하지 않습니다.

## 목적

Generator 구현 없이 `python-cli-automation` profile의 fragment·skill 구성이 Codex project instruction preview로 조합 가능한지 검증한다. Python 언어 규칙, CLI automation architecture와 automation skill routing이 Codex adapter 계약에 따라 조합되는지 확인한다.

## Dry-run 대상

- Profile: `profiles/python-cli-automation/profile.yml`
- Profile ID: `python-cli-automation`
- Adapter: `adapters/codex/adapter.md`
- Template: `templates/codex/AGENTS.md.template`
- Preview 상태: `ready`

## 산출물

| 파일 | 역할 |
| --- | --- |
| `AGENTS.preview.md` | Python CLI/automation project instruction preview example |
| `merge-trace.md` | Fragment 순서, dependency, compatibility와 중복 기록 |
| `skill-selection.md` | Common·testing·automation skill routing 기록 |
| `validation-report.md` | 수동 검증과 readiness 판정 |

## Architecture와 제약

- `stacks/architecture/cli-automation/agents.fragment.md`가 command, side effect, retry와 workflow 경계를 제공한다.
- CLI framework와 package manager는 정해지지 않았으며 preview에서 추정하지 않는다.
- 실제 project 목적, package 구조, Python version과 build/test/lint 명령은 입력되지 않았다.
- Git-auto workflow skill은 hook 운영 또는 pending publish 복구 시에만 참조하며 hook 로직을 생성하거나 수정하지 않는다.

## 현재 범위

이 example은 설계 검증 문서다. Generator, validator, CLI, file writer, skill 설치와 실제 export는 수행하지 않았다.
