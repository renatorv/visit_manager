import 'package:get_it/get_it.dart';

import '../../data/datasources/visit_local_datasource.dart';
import '../../data/repositories/visit_repository_impl.dart';
import '../../domain/repositories/visit_repository.dart';
import '../../domain/usecases/add_visit_usecase.dart';
import '../../domain/usecases/delete_visit_usecase.dart';
import '../../domain/usecases/get_all_visits_usecase.dart';
import '../../domain/usecases/update_visit_usecase.dart';
import '../../presentation/cubits/visit_cubit.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // Data sources
  sl.registerLazySingleton<VisitLocalDataSource>(
    () => VisitLocalDataSourceImpl(),
  );

  // Repositories
  sl.registerLazySingleton<VisitRepository>(
    () => VisitRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllVisitsUseCase(sl()));
  sl.registerLazySingleton(() => AddVisitUseCase(sl()));
  sl.registerLazySingleton(() => UpdateVisitUseCase(sl()));
  sl.registerLazySingleton(() => DeleteVisitUseCase(sl()));

  // Cubits (factory para criar nova instância por página)
  sl.registerFactory(
    () => VisitCubit(
      getAllVisitsUseCase: sl(),
      addVisitUseCase: sl(),
      updateVisitUseCase: sl(),
      deleteVisitUseCase: sl(),
    ),
  );
}
