# MVP File Structure 계획

## 현재 Repository 상태

현재 repository는 Markdown/YAML 설계 자산과 git-auto hook만 가지며 application package, runtime source, test tree와 package manager 초기화 파일이 없다. Phase 10-4에서는 디렉터리와 설정 파일을 실제 생성하지 않는다.

## 구현 언어와 Package Manager 제안

- 권장 언어: Python 3
- 권장 package/environment manager: `uv`
- 권장 project metadata: Repository root의 `pyproject.toml`

Python은 YAML 중심의 read-only 변환, 작은 module 경계와 fixture 기반 test에 필요한 구조를 적은 초기 비용으로 제공한다. `pyproject.toml` 기반 구성은 Python packaging 표준과 맞고, `uv`는 environment·dependency·test 실행을 하나의 project workflow로 관리하는 후보다. 구체 Python version과 dependency는 Phase 11 초기화 승인 시 확정한다.

## 후보 비교

| 후보 | 장점 | 제약 | 판단 |
| --- | --- | --- | --- |
| `packages/` | 여러 runtime package와 Web UI가 함께 있을 때 확장 가능 | 단일 MVP에 불필요한 monorepo 구조 | 보류 |
| `src/` | 단일 Python package와 문서 자산을 명확히 분리 | 향후 별도 app은 독립 경로 필요 | 권장 |
| `tools/` | 내부 보조 script 배치에 익숙함 | 제품 core와 일회성 도구의 경계가 흐려짐 | 제외 |
| Root module | 가장 단순함 | 문서/YAML과 runtime source가 섞이고 import/test 경계가 불명확 | 제외 |

`tests/`는 source 후보가 아니라 선택한 runtime package의 검증 tree로 별도 둔다.

## 최종 권장 구조

다음은 Phase 11에서 생성할 후보 구조이며 이번 작업에서는 만들지 않는다.

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
```

- `src/agentforge/`: Read-only core와 Codex planning 책임
- `tests/unit/`: Module별 순수 책임 검증
- `tests/integration/`: 실제 repository catalog/profile을 함께 읽는 계약 검증
- `tests/fixtures/`: Missing path, duplicate ID, variant와 pending 사례의 최소 입력

세부 file/class 이름은 module boundary를 구현할 때 언어 관례에 맞춰 정한다. `apps/`, Web UI, API, DB와 target output directory는 MVP 구조에 추가하지 않는다.

## 향후 확장과의 경계

Web UI가 승인되면 runtime core를 재사용하되 별도 application tree에서 의존하도록 한다. 현재 `src/agentforge/`에 UI, HTTP, persistence와 installer 책임을 넣지 않는다. Claude/Gemini adapter는 각 계약이 `mvp-contract`가 된 뒤 adapter-specific package 경계를 별도로 검토한다.

## 생성 금지 범위

Phase 10-4에서는 `src/`, `tests/`, `pyproject.toml`, lock file과 dependency 설정을 생성하지 않는다. 이 문서는 Phase 11 초기화 변경의 review 기준만 제공한다.
