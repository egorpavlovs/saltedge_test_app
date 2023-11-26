eng:

About the solution to the test task:

1. The verification request was changed to GET to better align with REST principles.

2. To run the application, copy `.env.example` to `.env`. Sidekiq is started with `bundle exec sidekiq` and updates the lists every morning.

3. The project is deployed at https://saltedge-test-app.onrender.com/. However, since Sidekiq requires payment, you can check updating only locally.

4. Suggestions for further project development:
- Add `rubocop`, `erb-lint`, `rails_best_practices`, `brakeman` (for security vulnerabilities), and `bundler-audit` (for patch-level verification with bundler).
- Implement `github actions` or `SemaphoreCI` with the mentioned checks and tests.
- Add feature tests to check the UI.
- Move `verifier` and `sanctionable_entities_refresher` to `app/services/` for the Service Object pattern. Also, use the `.call` method in `verifier` instead of `.run`.
- Move the database query from `SanctionableEntity.find_by_extra_field` to a separate Query Object if the amount of logic increases.

ru:

Про решение тестового задания:
1. Запрос на верификацию был изменен на GET, чтобы больше соответствовать REST.

2. Для работы приложения скопируйте `.env.example` в .`env`. Sidekiq запускается `bundle exec sidekiq` и обновляет списки каждое утро.

3. Проект задеплоен в https://saltedge-test-app.onrender.com/. Однако за sidekiq надо платить, поэтому проверить обновление можно локально.

4. Предложения по дальнейшему развитию проекта:
- Добавить `rubocop`, `erb-lint`, `rails_best_practices`, `brakeman` (security vulnerabilities) и `bundler-audit` (patch-level verification for bundler).
- Добавить `github actions` или `SemaphoreCI` с вышеперечисленными проверками и тестами.
- Добавить feature тесты для проверки UI.
- Перенести `verifier` и `sanctionable_entities_refresher` в `app/services/` для Service Object паттерна. Также использовать в `verifier` метод `.call`, вместо `.run`.
- Перенести запрос в БД из `SanctionableEntity.find_by_extra_field` в отдельный Query Object, если количество логики будет увеличиваться.
