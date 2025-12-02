import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ppt_generator/core/services/ppt_service.dart';
import 'package:ppt_generator/core/services/supabase_service.dart';
import 'package:ppt_generator/features/home_screen/data/models/ppt_request_model.dart';
import 'package:ppt_generator/features/home_screen/presentation/bloc/ppt_generator_event.dart';
import 'package:ppt_generator/features/home_screen/presentation/bloc/ppt_generator_state.dart';

class PptGeneratorBloc extends Bloc<PptGeneratorEvent, PptGeneratorState> {
  final PptService _pptService;
  final SupabaseService _supabaseService;

  PptGeneratorBloc({PptService? pptService, SupabaseService? supabaseService})
    : _pptService = pptService ?? PptService(),
      _supabaseService = supabaseService ?? SupabaseService.instance,
      super(PptGeneratorInitial()) {
    on<GeneratePptRequested>(_onGeneratePptRequested);
  }

  Future<void> _onGeneratePptRequested(
    GeneratePptRequested event,
    Emitter<PptGeneratorState> emit,
  ) async {
    emit(PptGeneratorLoading());
    try {
      final requestBody = PptRequestModel(
        topic: event.topic,
        extraInfoSource: event.extraInfoSource,
        email: event.email,
        accessId: event.accessId,
        presentationFor: event.audience,
        slideCount: event.slideCount,
        language: event.language,
        template: event.templateStyle,
        model: event.model,
        aiImages: event.aiImages,
        imageForEachSlide: event.imageOnEachSlide,
        googleImage: event.googleImages,
        googleText: event.googleText,
        watermark: event.watermark,
      );

      final response = await _pptService.generatePpt(requestBody);

      try {
        final user = _supabaseService.currentUser;
        int? userInfoId;
        if (user != null) {
          userInfoId = await _supabaseService.getUserInfoId(user.id);
        }

        await _supabaseService.insertPptGenerationInfo({
          'user_info_id': userInfoId,
          'topic': event.topic,
          'extra_info_source': event.extraInfoSource.isEmpty
              ? null
              : event.extraInfoSource,
          'template': event.templateStyle,
          'language': event.language,
          'slide_count': event.slideCount,
          'ai_images': event.aiImages,
          'image_for_each_slide': event.imageOnEachSlide,
          'google_image': event.googleImages,
          'google_text': event.googleText,
          'model': event.model,
          'presentation_for': event.audience.isEmpty ? null : event.audience,
          'watermark': event.watermark,
          'result_url': response.data?.url,
          'result_success': response.success,
          'user_id': user?.id,
        });
      } catch (e) {
        print('DB Insert Error: $e');
      }

      if (response.success && response.data != null) {
        emit(PptGeneratorSuccess(pptUrl: response.data!.url));
      } else {
        emit(
          PptGeneratorFailure(
            message: response.message ?? 'Unknown error occurred',
          ),
        );
      }
    } catch (e) {
      emit(PptGeneratorFailure(message: e.toString()));
    }
  }
}
