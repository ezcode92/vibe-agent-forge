# Fragment Merge Trace

> `python-cli-automation` + Codex 수동 dry-run의 source 추적 문서다. 실제 merge engine 실행 결과가 아니다.

## 선택된 Fragment

| Profile 구분 | Catalog ID | Path | Priority |
| --- | --- | --- | --- |
| Base | `core-global` | `core/global/agents.fragment.md` | 10 |
| Base/project | `core-project` | `core/project/agents.fragment.md` | 70 |
| Quality | `core-quality` | `core/quality/agents.fragment.md` | 10 |
| Language | `language-python` | `stacks/language/python/agents.fragment.md` | 20 |

Profile이 참조한 fragment 4개는 catalog path와 일치하며 모두 존재한다. Bridge는 선택되지 않았다.

## Preview 구성 및 Authority

표시 순서는 Core → Python → project placeholder다. Conflict authority는 priority 10의 global/quality, priority 20의 Python, priority 70의 project 구조, 사용자 현재 요청 순으로 검토한다. Project metadata가 없으므로 `core-project`의 slot은 placeholder로 유지한다.

## Dependency 확인

- `core-project` → `core-global`: 충족
- `core-quality` → `core-global`: 충족
- `language-python` → `core-quality`: 충족

## Architecture Pending

Profile constraint의 `architecture-fragment`는 `architecture fragment pending` 상태다. 이는 존재해야 할 source path로 해석하지 않았고 임의의 monolith, clean 또는 hexagonal architecture fragment를 선택하지 않았다. Python 언어 규칙과 preview 구조는 구성할 수 있지만 실제 command/module 책임 경계는 적용 전에 결정해야 하므로 warning으로 유지한다.

## 중복과 충돌

- Core와 Python의 일반 검증·최소 변경 원칙은 공통 문장으로 한 번만 요약했다.
- Core 보안과 Python path/exception 규칙은 일반 신뢰 경계와 언어별 처리 책임으로 구분했다.
- Framework, architecture와 bridge가 선택되지 않아 catalog conflict는 없다.
- CLI framework와 package manager를 추정하지 않아 profile exclude 조건을 지켰다.

## 결과

필수 source와 dependency는 유효하지만 architecture pending의 수동 결정이 남아 있다. Preview는 실제 export가 아닌 `ready-with-warnings` example로 구성한다.
