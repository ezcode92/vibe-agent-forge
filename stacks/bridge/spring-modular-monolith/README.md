# Spring–Modular Monolith Bridge

## 목적

Spring bean·transaction 경계를 Modular Monolith의 공개 API, 의존 방향과 데이터 소유권에 연결하는 조합 책임을 안내합니다.

## 포함된 문서 자산

- `agents.fragment.md`: Spring–Modular Monolith bridge fragment
- Catalog 항목: `registry/fragments.yml`의 `bridge-spring-modular-monolith`

## 관련 Profile과 Dry-run

- Spring backend profile과 `profiles/fullstack-spring-react/profile.yml`
- `examples/codex/backend-kotlin-spring-rdb/` 및 fullstack Kotlin/Java dry-run

## 현재 범위

이 디렉터리는 두 stack 사이의 조합 규칙을 제공하는 문서 자산입니다. Module template, Spring 설정과 애플리케이션 코드는 포함하지 않습니다.
