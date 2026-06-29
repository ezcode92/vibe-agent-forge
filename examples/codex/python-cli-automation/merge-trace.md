# Fragment Merge Trace

> `python-cli-automation` + Codex 수동 dry-run의 source 추적 문서다. 실제 merge engine 실행 결과가 아니다.

## 선택된 Fragment

| Profile 구분 | Catalog ID | Path | Priority |
| --- | --- | --- | --- |
| Base | `core-global` | `core/global/agents.fragment.md` | 10 |
| Base/project | `core-project` | `core/project/agents.fragment.md` | 70 |
| Quality | `core-quality` | `core/quality/agents.fragment.md` | 10 |
| Language | `language-python` | `stacks/language/python/agents.fragment.md` | 20 |
| Architecture | `architecture-cli-automation` | `stacks/architecture/cli-automation/agents.fragment.md` | 30 |

Profile이 참조한 fragment 5개는 catalog path와 일치하며 모두 존재한다. Bridge는 선택되지 않았다.

## Preview 구성 및 Authority

표시 순서는 Core → Python → CLI Automation Architecture → project placeholder다. Conflict authority는 priority 10의 global/quality, priority 20의 Python, priority 30의 architecture, priority 70의 project 구조, 사용자 현재 요청 순으로 검토한다. Project metadata가 없으므로 `core-project`의 slot은 placeholder로 유지한다.

## Dependency 확인

- `core-project` → `core-global`: 충족
- `core-quality` → `core-global`: 충족
- `language-python` → `core-quality`: 충족
- `architecture-cli-automation` → `core-quality`: 충족

## Compatibility 확인

Python + CLI Automation Architecture 관계는 `compatible`, `supported`이며 required bridge가 없다. 언어 fragment는 typing, exception, path와 resource 규칙을 소유하고 architecture fragment는 command, side effect, batch와 workflow 경계를 소유하므로 별도 변환 규칙 없이 조합한다. 기존 architecture pending은 새 fragment 선택으로 해소됐다.

## 중복과 충돌

- Core와 Python의 일반 검증·최소 변경 원칙은 공통 문장으로 한 번만 요약했다.
- Python path/resource 규칙과 architecture의 filesystem/process 경계는 언어 사용과 side effect 소유권으로 구분했다.
- Core 보안과 architecture logging/output 규칙은 일반 민감정보 보호와 실행 결과 계약으로 구분했다.
- 다른 architecture와 bridge가 선택되지 않아 catalog conflict는 없다.
- CLI framework와 package manager를 추정하지 않아 profile exclude 조건을 지켰다.

## 결과

필수 source, dependency와 compatibility가 유효하고 architecture pending이 해소됐다. Preview는 실제 export가 아닌 `ready` example로 구성한다.
