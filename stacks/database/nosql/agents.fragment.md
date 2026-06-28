# NoSQL Fragment

## 목적

Document, key-value, wide-column과 search 계열 저장소를 포괄하는 access pattern, consistency, partition, schema와 무결성 원칙을 정의한다. 특정 제품, client library와 framework 사용법은 다루지 않는다.

## 적용 대상

- Stack 식별자: `database-nosql`
- 적용 조건: 관계 모델보다 특정 접근 패턴, 분산 확장 또는 검색 특성에 맞춘 저장소
- 제외 조건: 제품별 query 언어, cluster 설정, index 문법과 운영 명령

## 핵심 규칙

- 먼저 필요한 read/write access pattern, 빈도, 데이터 규모와 latency 목표를 정의한 뒤 model과 저장소 계열을 선택한다.
- Key와 partition 기준은 데이터 분포, locality, hotspot, 최대 항목 크기와 조회 범위를 함께 고려한다.
- Consistency 모델은 읽기 최신성, 동시 쓰기, 충돌 해결과 실패 시 허용 결과를 use case별로 명시한다.
- Schema를 database가 강제하지 않더라도 application 계약, validation, version과 migration 책임을 정의한다.
- 중복 데이터는 허용 이유, 원본 소유자, 갱신 순서와 불일치 복구 방법이 있을 때만 사용한다.
- 검색용 index나 파생 view는 원본 데이터와 구분하고 지연, 재구축 및 누락 복구 정책을 둔다.

## 권장 패턴

- 대표 access pattern별 key, projection, pagination과 예상 비용을 설계 시 함께 기록한다.
- 조건부 쓰기, version 또는 idempotency가 필요한 경쟁 조건을 식별하고 저장소 capability와 대조한다.
- Document와 item의 크기 증가, unbounded collection과 hot partition 가능성을 사전에 제한한다.
- Schema 변경은 mixed-version 데이터를 읽을 수 있는 호환 구간과 backfill·검증 방법을 포함한다.

## 금지 패턴

- “Schema-less”를 데이터 계약, validation과 migration이 필요 없다는 의미로 사용하지 않는다.
- 관계형 model을 그대로 복제하거나 access pattern 없이 범용 저장소로 선택하지 않는다.
- 강한 consistency 또는 transaction을 제품 확인 없이 가정하지 않는다.
- 무제한 scan, hot key, 무한히 커지는 document/collection을 정상 조회 경로로 설계하지 않는다.
- 검색 index나 cache 성격의 저장소를 소유권·복구 계획 없이 유일한 원본으로 취급하지 않는다.

## 검증 기준

- 저장소 계열과 model 선택이 구체적인 access pattern 및 규모 요구와 연결된다.
- Partition 분포, hotspot, 항목 크기와 query 비용의 상한을 검토했다.
- Consistency, 경쟁 쓰기, 재시도와 충돌 해결 결과가 use case별로 정의된다.
- Schema version, validation, migration과 중복 데이터 복구 책임이 명확하다.
- 제품 capability가 필요한 판단은 product-specific 문서 또는 fragment에서 별도로 검증된다.

## 관련 skill

- 필수 skill: 없음
- 선택 skill: NoSQL access pattern 또는 consistency 검토 skill이 registry에 등록된 이후 해당 작업 조건에서만 참조한다.

## Bridge 필요 조건

- 특정 제품 capability를 일반 NoSQL 규칙에 연결할 때 product-specific fragment가 필요하다.
- Framework data access 또는 architecture의 데이터 소유권과 연결할 때 해당 조합 bridge가 필요하다.
