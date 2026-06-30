# MVP File Structure 계획

## 현재 Repository 상태

현재 repository는 Markdown/YAML 설계 자산과 git-auto hook만 가지며 application package, runtime source, test tree와 package manager 초기화 파일이 없다. Phase 10-4에서는 디렉터리와 설정 파일을 실제 생성하지 않는다.

## 확정 Runtime과 Package 정책

- Python requirement: `>=3.12`
- Phase 11-1 기준 runtime/test baseline: Python 3.12
- Package/environment manager: `uv`
- Project metadata: Repository root의 `pyproject.toml`
- Lock file: `uv.lock`

Python 3.12를 최소 기준으로 사용하고 이후 Python version 지원 확대는 별도 호환성 검증으로 다룬다. `pyproject.toml`은 project와 dependency metadata의 source of truth이며 `uv.lock`은 Phase 11-1 환경의 재현 가능한 dependency 해석 결과를 고정한다.

## Dependency 정책

### Runtime

- `PyYAML`: Registry와 profile YAML parse에만 사용한다.

Runtime dependency에는 CLI, Web, validation framework, template engine, database와 AI library를 추가하지 않는다. Python standard library로 충분한 path, collection, data model과 serialization planning 책임은 외부 dependency를 도입하지 않는다.

### Development

- `pytest`: Unit/integration test 실행
- `ruff`: Lint와 format check
- `mypy`: Static type check

`pyright`와 중복 type checker, test plugin, coverage service와 packaging helper는 구체 필요가 확인되기 전에는 추가하지 않는다.

### Version과 Lock

- Direct dependency compatible range는 `pyproject.toml`에 선언한다.
- 정확한 transitive resolution은 `uv.lock`에 기록한다.
- Dependency 추가·교체는 module 책임과 acceptance criteria로 필요성을 설명한 뒤 별도 review한다.
- 실제 version range와 lock 내용은 Phase 11-1 dependency 초기화 변경에서 검증한다.

## Quality Command 정책

- Test: `uv run pytest`
- Lint: `uv run ruff check .`
- Format check: `uv run ruff format --check .`
- Type check: `uv run mypy src`

Phase 11-1에서는 네 명령을 project-level 검증 계약으로 만들고 모두 통과해야 완료로 판정한다. 자동 rewrite format command는 검증 명령과 분리한다.

## 후보 비교

| 후보 | 장점 | 제약 | 판단 |
| --- | --- | --- | --- |
| `packages/` | 여러 runtime package와 Web UI가 함께 있을 때 확장 가능 | 단일 MVP에 불필요한 monorepo 구조 | 보류 |
| `src/` | 단일 Python package와 문서 자산을 명확히 분리 | 향후 별도 app은 독립 경로 필요 | 권장 |
| `tools/` | 내부 보조 script 배치에 익숙함 | 제품 core와 일회성 도구의 경계가 흐려짐 | 제외 |
| Root module | 가장 단순함 | 문서/YAML과 runtime source가 섞이고 import/test 경계가 불명확 | 제외 |

`tests/`는 source 후보가 아니라 선택한 runtime package의 검증 tree로 별도 둔다.

## 최종 권장 구조

다음은 Phase 11-1에서 생성할 후보 구조이며 이번 작업에서는 만들지 않는다.

```text
pyproject.toml
src/
└── agentforge/
    ├── loading/
    ├── resolution/
    ├── validation/
    ├── planning/
    └── reporting/
tests/
├── unit/
├── integration/
└── fixtures/
uv.lock
```

- `src/agentforge/`: Read-only core와 Codex planning 책임
- `tests/unit/`: Module별 순수 책임 검증
- `tests/integration/`: 실제 repository catalog/profile을 함께 읽는 계약 검증
- `tests/fixtures/`: Missing path, duplicate ID, variant와 pending 사례의 최소 입력

세부 file/class 이름은 module boundary를 구현할 때 언어 관례에 맞춰 정한다. `apps/`, Web UI, API, DB와 target output directory는 MVP 구조에 추가하지 않는다.

## Phase 11-1 생성 허용 범위

- `pyproject.toml`, `uv.lock`
- `src/agentforge/` package marker와 loader/path/report model에 필요한 Python module
- `tests/unit/`의 registry loader, profile loader, path validation과 report test
- `tests/integration/`의 repository catalog/profile parse test
- `tests/fixtures/`의 최소 오류 입력

정확한 file 이름은 위 책임 범위를 벗어나지 않는 선에서 Phase 11-1 구현 plan에 정한다. Package skeleton만을 위한 빈 abstraction이나 future module placeholder는 만들지 않는다.

## Phase 11-1 생성 금지 범위

- CLI entrypoint, `__main__`, command package와 shell script
- Preview renderer, template materializer, output/export writer
- Adapter-specific renderer, Claude/Gemini module과 MSA bridge
- Web UI, HTTP/API, database/persistence와 installer package
- Root `AGENTS.md`, `.codex/`, `.gitauto/`를 다루는 helper
- `package.json`, TypeScript/Gradle config와 별도 language runtime 설정

## 향후 확장과의 경계

Web UI가 승인되면 runtime core를 재사용하되 별도 application tree에서 의존하도록 한다. 현재 `src/agentforge/`에 UI, HTTP, persistence와 installer 책임을 넣지 않는다. Claude/Gemini adapter는 각 계약이 `mvp-contract`가 된 뒤 adapter-specific package 경계를 별도로 검토한다.

## 생성 금지 범위

Phase 11-0에서는 `src/`, `tests/`, `pyproject.toml`, `uv.lock`과 dependency 설정을 생성하지 않는다. 이 문서는 Phase 11-1 초기화 변경의 review 기준만 제공한다.
