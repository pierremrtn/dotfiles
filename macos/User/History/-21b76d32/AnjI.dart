part of 'state_machine.dart';

/// Object used to describe state machine's states
///
/// [StateDefinitionBuilder] provides methods to register state's event handlers.
/// and side effect as well nested states.
/// * [on] method is used to register event handlers.
/// * [onEnter], [onChange], [onExit] methods are used to register side effects.
/// * [define] method is used to defined nested state.
///
/// ```dart
/// define<ParentState>((StateDefinitionBuilder b) => b
///   ..onEnter(...)
///   ..onChange(...)
///   ..onExit(...)
///   ..on<Event1>(...)
///   ..define<ChildState1>(...)
/// );
/// ```
class StateDefinitionBuilder<Event, State, DefinedState extends State> {
  final List<Type> _definedStates = [];
  final List<_StateEventHandler> _handlers = [];
  final List<_StateDefinition> _nestedStateDefinitions = [];
  SideEffect<DefinedState>? _onEnter;
  SideEffect<DefinedState>? _onExit;
  OnChangeSideEffect<DefinedState>? _onChange;

  /// Register [onEnterCallback] function as onEnter side effect for [DefinedState]
  ///
  /// [onEnter] should only be called once per unique state.
  ///
  /// [onEnterCallback] will be called when the state machine enter
  /// [DefinedState] or one of its nested states **for the first** time.
  /// It will not be called if previous state is [DefinedState] or one of its
  /// nested states.
  ///
  /// [onEnterCallback] callback could be async but **will not** be awaited.
  ///
  /// ```dart
  /// define<ParentState>(($) => $
  ///   ..onEnter((ParentState state) {
  ///      // Custom code called when entering the state
  ///      // Generally a good place to start async computation
  ///   })
  /// );
  /// ```
  void onEnter(SideEffect<DefinedState> onEnterCallback) {
    assert(() {
      if (_onEnter != null) {
        throw StateError(
          'onEnter was called multiple times.'
          'There should only be a single onEnter side effect registered per state.',
        );
      }
      return true;
    }());
    _onEnter = onEnterCallback;
  }

  /// Register [onExitCallback] function as onExit side effect for [DefinedState]
  ///
  /// [onExit] should only be called once per unique state.
  ///
  /// [onExitCallback] will be called when the state machine exit [DefinedState].
  /// It will not be called if next state is one of [DefinedState]'s nested states.
  ///
  /// [onExitCallback] callback could be async but **will not** be awaited.
  ///
  /// ```dart
  /// define<ParentState>(($) => $
  ///   ..onExit((ParentState state) {
  ///      // Custom code called when exiting the state
  ///   })
  /// );
  /// ```
  void onExit(SideEffect<DefinedState> onExitCallback) {
    assert(() {
      if (_onExit != null) {
        throw StateError(
          'onExit was called multiple times.'
          'There should only be a single onExit side effect registered per state.',
        );
      }
      return true;
    }());
    _onExit = onExitCallback;
  }

  /// Register [onChangeCallback] function as onChange side effect for [DefinedState]
  ///
  /// [onChange] should only be called once per unique state.
  ///
  /// [onChangeCallback] will be called when the state machine enter
  /// [DefinedState] or one of its nested states **and** previous state **was**
  /// [DefinedState] or one of its nested states.
  ///
  /// [onChangeCallback] It **will not** be called the first time state machine
  /// enter [DefinedState] or one of its nested states.
  ///
  /// 🚨 State machine discard any state update where `currentState == nextState`,
  /// so make sure you've implemented [operator==] for your state class,
  /// otherwise onChange will not be called.
  ///
  /// [onChangeCallback] callback could be async but **will not** be awaited.
  ///
  /// ```dart
  /// define<ParentState>(($) => $
  ///   ..onChange((ParentState currentState, ParentState nextState) {
  ///      // Custom code called when this state changed
  ///   })
  /// );
  /// ```
  void onChange(OnChangeSideEffect<DefinedState> onChangeCallback) {
    assert(() {
      if (_onChange != null) {
        throw StateError(
          'onChange was called multiple times.'
          'There should only be a single side effect onChange effect per state.',
        );
      }
      return true;
    }());
    _onChange = onChangeCallback;
  }

  /// Register [transition] function as one of [DefinedState]'s event handler
  /// for [DefinedEvent]
  ///
  /// - If [transition] return a [State], state machine stops any further
  /// event handlers evaluation and transition to the returned state.
  /// - If [transition] return null, state machine will continue other event
  /// handlers evaluation.
  ///
  /// You can have multiple event handlers registered for the same [DefinedEvent].
  /// When an event is received, every handlers that match event will be evaluated
  /// **in their definition order**. Parent states's event handlers are always
  /// evaluated before nested states handlers so if a parent transit to a new
  /// state, children handlers will not be evaluated.
  ///
  /// ```dart
  /// define<ParentState>(($) => $
  ///   ..on<DefinedEvent>((DefinedEvent event, ParentState state) {
  ///      // return next state or null
  ///   })
  ///   ..on<DefinedEvent>((DefinedEvent event, ParentState state) {
  ///      // multiple handlers for a give event type
  ///      return NextState();
  ///   })
  ///   ..on<OtherEvent>((OtherEvent event, ParentState state) {
  ///      // use event and current state's data to assemble next state
  ///      return NextState(event.data + state.data);
  ///   })
  /// );
  /// ```
  void on<DefinedEvent extends Event>(
    EventTransition<DefinedEvent, State, DefinedState> transition,
  ) =>
      _handlers.add(
        _StateEventHandler<Event, State, DefinedEvent, DefinedState>(
          transition: transition,
          isType: (dynamic e) => e is DefinedEvent,
          type: DefinedEvent,
        ),
      );

  /// Define a nested state
  ///
  /// Works the same way than top-level define calls.
  /// [builder] function that takes a [StateDefinitionBuilder] as parameter
  /// and should return it. [StateDefinitionBuilder] is used to register event
  /// handlers and side effects to for the defined [NestedState].
  ///
  /// Nested states should always be sub-classes of their parent state.
  ///
  /// Their is no depth limit in state nesting but you should never define a
  /// state more than ones.
  ///
  /// Nested states event handlers and side effects are always evaluated after
  /// parent's ones.
  void define<NestedState extends DefinedState>([
    StateDefinitionBuilder<Event, State, NestedState> Function(
            StateDefinitionBuilder<Event, State, NestedState>)?
        builder,
  ]) {
    late _StateDefinition definition;
    if (builder != null) {
      definition = builder
          .call(StateDefinitionBuilder<Event, State, NestedState>())
          ._build();
    } else {
      definition = _StateDefinition<Event, State, NestedState>.empty();
    }

    assert(() {
      if (_definedStates.contains(NestedState)) {
        throw "$NestedState defined multiple times. State should only be defined once.";
      }
      _definedStates.add(NestedState);
      return true;
    }());

    _nestedStateDefinitions.add(definition);
  }

  _StateDefinition<Event, State, DefinedState> _build() => _StateDefinition(
        handlers: _handlers,
        nestedStatesDefinitions:
            _nestedStateDefinitions.isNotEmpty ? _nestedStateDefinitions : null,
        onEnter: _onEnter,
        onExit: _onExit,
        onChange: _onChange,
      );
}
