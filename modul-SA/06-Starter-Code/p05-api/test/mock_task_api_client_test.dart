import 'package:flutter_test/flutter_test.dart';
import 'package:p05_api/core/errors/api_error.dart';
import 'package:p05_api/features/tasks/data/remote/mock_task_api_client.dart';
import 'package:p05_api/features/tasks/domain/task.dart';

/// Test [MockTaskApiClient] sebagai fixture fallback. Hijau sejak starter,
/// membuktikan P05 bisa diuji tanpa server eksternal (acceptance criteria).
void main() {
  late MockTaskApiClient client;

  setUp(() {
    client = MockTaskApiClient();
  });

  test('listTasks mengembalikan fixture (GET offline)', () async {
    final tasks = await client.listTasks();

    expect(tasks.length, 3);
    expect(tasks.any((t) => t.id == 'f01'), isTrue);
    expect(tasks.first.title, startsWith('Fixture:'));
  });

  test('createTask menambah dan muncul di listTasks', () async {
    final created = await client.createTask(
      Task(
        id: 'new1',
        title: 'New From Test',
        description: 'created',
        dueDate: DateTime.utc(2026, 10, 1),
        priority: TaskPriority.low,
      ),
    );

    expect(created.id, 'new1');
    final all = await client.listTasks();
    expect(all.any((t) => t.id == 'new1'), isTrue);
  });

  test('createTask id duplikat -> ClientError 409', () async {
    await expectLater(
      client.createTask(
        Task(
          id: 'f01',
          title: 'Dup',
          description: '',
          dueDate: DateTime.utc(2026, 10, 1),
        ),
      ),
      throwsA(isA<ClientError>()),
    );
  });

  test('updateTask memperbarui field', () async {
    final original = (await client.listTasks()).firstWhere((t) => t.id == 'f02');
    await client.updateTask(original.copyWith(title: 'Updated Title'));

    final updated = (await client.listTasks()).firstWhere((t) => t.id == 'f02');
    expect(updated.title, 'Updated Title');
  });

  test('updateTask id tidak ada -> NotFoundError', () async {
    await expectLater(
      client.updateTask(
        Task(
          id: 'missing',
          title: 'X',
          description: '',
          dueDate: DateTime.utc(2026, 10, 1),
        ),
      ),
      throwsA(isA<NotFoundError>()),
    );
  });

  test('deleteTask menghapus', () async {
    await client.deleteTask('f03');
    final all = await client.listTasks();
    expect(all.any((t) => t.id == 'f03'), isFalse);
  });

  test('simulateNetworkError -> NetworkError (state error UI)', () async {
    client.simulateNetworkError = true;
    await expectLater(client.listTasks(), throwsA(isA<NetworkError>()));
  });
}
