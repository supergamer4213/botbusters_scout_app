import 'dart:convert';

import 'package:botbusters_scout_app/providers/robots_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';

import 'package:botbusters_scout_app/classes/robot.dart';
import 'package:botbusters_scout_app/providers/scout_data_provider.dart';
import 'package:botbusters_scout_app/screens/qr_screen.dart';
import 'package:botbusters_scout_app/widgets/alliance_buttons.dart';
import 'package:botbusters_scout_app/widgets/counter.dart';
import 'package:botbusters_scout_app/widgets/driver_skill_buttons.dart';
import 'package:botbusters_scout_app/widgets/final_status_buttons.dart';
import 'package:botbusters_scout_app/widgets/floor_pickup_buttons.dart';
import 'package:botbusters_scout_app/widgets/write_number_widget.dart';

class SendScreen extends StatefulWidget {
  const SendScreen({super.key});

  static const routeName = '/send';

  @override
  State<SendScreen> createState() => _SendScreenState();
}

class _SendScreenState extends State<SendScreen> {
  final _formKey = GlobalKey<FormState>();

  // Normal
  final _teamNumberController = TextEditingController();
  final _matchNumberController = TextEditingController();

  String _allianceId = 'blue1';

  // Autonomous
  int _autoTopScored = 0;
  int _autoMiddleScored = 0;
  int _autoBottomScored = 0;

  bool _leftCommunity = false;
  bool _docked = false;
  bool _engaged = false;

  // Tele-Op
  int _teleopTopScored = 0;
  int _teleopMiddleScored = 0;
  int _teleopBottomScored = 0;
  int _teleopLinksScored = 0;

  bool _coopBonus = false;
  bool _wasDefended = false;

  String _floorPickupId = 'none';

  // Endgame
  int _dockingTimer = 0;

  String _finalStatusId = 'notAttempted';

  int _allianceRobots = 0;

  // Extras
  String _driverSkillId = 'notObs';

  int _speedRating = 0;

  bool _missedPieces = false;
  bool _died = false;
  bool _tippy = false;
  bool _errorFoul = false;
  bool _mechFail = false;
  bool _defense = false;

  final _commentController = TextEditingController();

  // State variables
  bool _isLoading = false;
  bool _isEditing = false;
  String _previousId = '';

  // Running for once only...
  bool _firstTimeRunning = true;

  @override
  void didChangeDependencies() {
    if (_firstTimeRunning) {
      final editRobotData =
          ModalRoute.of(context)?.settings.arguments as Robot?;

      if (editRobotData != null) {
        // Normal
        _teamNumberController.text = editRobotData.teamNumber.toString();
        _matchNumberController.text = editRobotData.matchNumber.toString();
        _allianceId = editRobotData.allianceId;

        // Autonomous
        _autoTopScored = editRobotData.autoTopScored;
        _autoMiddleScored = editRobotData.autoMiddleScored;
        _autoBottomScored = editRobotData.autoBottomScored;
        _leftCommunity = editRobotData.leftCommunity;
        _docked = editRobotData.docked;
        _engaged = editRobotData.engaged;

        // Tele-Op
        _teleopTopScored = editRobotData.teleopTopScored;
        _teleopMiddleScored = editRobotData.teleopMiddleScored;
        _teleopBottomScored = editRobotData.teleopBottomScored;
        _teleopLinksScored = editRobotData.teleopLinksScored;
        _coopBonus = editRobotData.coopBonus;
        _wasDefended = editRobotData.wasDefended;
        _floorPickupId = editRobotData.floorPickupId;

        // Endgame
        _dockingTimer = editRobotData.dockingTimer;
        _finalStatusId = editRobotData.finalStatusId;
        _allianceRobots = editRobotData.allianceRobots;

        // Extras
        _driverSkillId = editRobotData.driverSkillId;
        _speedRating = editRobotData.speedRating;
        _missedPieces = editRobotData.missedPieces;
        _died = editRobotData.died;
        _tippy = editRobotData.tippy;
        _errorFoul = editRobotData.errorFoul;
        _mechFail = editRobotData.mechFail;
        _defense = editRobotData.defense;
        _commentController.text = editRobotData.comment;

        _previousId = editRobotData.id;

        _isEditing = true;
      }
      _firstTimeRunning = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Send'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WriteNumberWidget(
                  controller: _teamNumberController,
                  text: 'Team Number',
                ),
                const SizedBox(height: 15),
                WriteNumberWidget(
                  controller: _matchNumberController,
                  text: 'Match Number',
                ),
                const SizedBox(height: 30),
                const Text(
                  'Robot Alliance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                AllianceButtons(
                  allianceId: _allianceId,
                  onButtonPressed: (newId) {
                    _allianceId = newId;
                  },
                ),
                const SizedBox(height: 35),
                const Text(
                  'Autonomous',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Top Scored',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CoolCounter(
                      max: 9999,
                      min: 0,
                      value: _autoTopScored,
                      whenChanged: (newValue) {
                        _autoTopScored = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Middle Scored',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CoolCounter(
                      max: 9999,
                      min: 0,
                      value: _autoMiddleScored,
                      whenChanged: (newValue) {
                        _autoMiddleScored = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Bottom Scored',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CoolCounter(
                      max: 9999,
                      min: 0,
                      value: _autoBottomScored,
                      whenChanged: (newValue) {
                        _autoBottomScored = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _leftCommunity,
                      onToggle: (newValue) {
                        setState(() {
                          _leftCommunity = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Left Community',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _docked,
                      onToggle: (newValue) {
                        setState(() {
                          _docked = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Docked to Charging Station',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _engaged,
                      onToggle: (newValue) {
                        setState(() {
                          _engaged = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Engaged to Charging Station',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                const Text(
                  'Tele-Op',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Top Scored',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CoolCounter(
                      max: 9999,
                      min: 0,
                      value: _teleopTopScored,
                      whenChanged: (newValue) {
                        _teleopTopScored = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Middle Scored',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CoolCounter(
                      max: 9999,
                      min: 0,
                      value: _teleopMiddleScored,
                      whenChanged: (newValue) {
                        _teleopMiddleScored = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Bottom Scored',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CoolCounter(
                      max: 9999,
                      min: 0,
                      value: _teleopBottomScored,
                      whenChanged: (newValue) {
                        _teleopBottomScored = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Links Scored',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CoolCounter(
                      max: 9999,
                      min: 0,
                      value: _teleopLinksScored,
                      whenChanged: (newValue) {
                        _teleopLinksScored = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _coopBonus,
                      onToggle: (newValue) {
                        setState(() {
                          _coopBonus = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Co-Op Bonus',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _wasDefended,
                      onToggle: (newValue) {
                        setState(() {
                          _wasDefended = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Was Defended',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  'Floor Pickup',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                FloorPickupButtons(
                  floorPickupId: _floorPickupId,
                  onButtonPressed: (newId) {
                    _floorPickupId = newId;
                  },
                ),
                const SizedBox(height: 35),
                const Text(
                  'Endgame',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Docking Timer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CoolCounter(
                      max: 9999,
                      min: 0,
                      value: _dockingTimer,
                      whenChanged: (newValue) {
                        _dockingTimer = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Final Status',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                FinalStatusButtons(
                  finalStatusId: _finalStatusId,
                  onButtonPressed: (newId) {
                    _finalStatusId = newId;
                  },
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Alliance Robots\nDocked/Engaged',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    CoolCounter(
                      max: 9999,
                      min: 0,
                      value: _allianceRobots,
                      whenChanged: (newValue) {
                        _allianceRobots = newValue;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 35),
                const Text(
                  'Extras',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Driver Skill',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                DriverSkillButtons(
                  driverSkillId: _driverSkillId,
                  onButtonPressed: (newId) {
                    _driverSkillId = newId;
                  },
                ),
                const SizedBox(height: 15),
                const Text(
                  'Speed Rating',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Slider(
                  value: _speedRating.toDouble(),
                  onChanged: (val) {
                    setState(() {
                      _speedRating = val.toInt();
                    });
                  },
                  max: 10,
                  min: 0,
                  divisions: 10,
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _missedPieces,
                      onToggle: (newValue) {
                        setState(() {
                          _missedPieces = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      'Missed Pieces',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _died,
                      onToggle: (newValue) {
                        setState(() {
                          _died = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Died/Immobilized',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _tippy,
                      onToggle: (newValue) {
                        setState(() {
                          _tippy = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Tippy (Almost tipped over)',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _errorFoul,
                      onToggle: (newValue) {
                        setState(() {
                          _errorFoul = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Error or Foul',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _mechFail,
                      onToggle: (newValue) {
                        setState(() {
                          _mechFail = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Mechanical Failures',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    FlutterSwitch(
                      value: _defense,
                      onToggle: (newValue) {
                        setState(() {
                          _defense = newValue;
                        });
                      },
                      activeColor: const Color.fromRGBO(0, 220, 167, 1.0),
                      inactiveColor: const Color.fromRGBO(200, 200, 200, 1.0),
                      borderRadius: 12,
                      width: 47,
                      height: 27,
                      toggleSize: 16,
                      // iq 150 papu, pa que no se corra el toggle del switch le pongo
                      // un border del color verde, y así se ve más pequeño
                      activeToggleBorder: Border.all(
                        color: const Color.fromRGBO(0, 220, 167, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      inactiveToggleBorder: Border.all(
                        color: const Color.fromRGBO(200, 200, 200, 1.0),
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    const SizedBox(width: 25),
                    const Text(
                      'Played Defense',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: const Color.fromARGB(255, 239, 239, 239),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  child: TextFormField(
                    controller: _commentController,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Type here...',
                    ),
                    buildCounter: (
                      context, {
                      required int currentLength,
                      required bool isFocused,
                      required int? maxLength,
                    }) =>
                        null,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    maxLength: 100,
                    maxLines: 5,
                  ),
                ),
                const SizedBox(height: 25),
                CupertinoButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          setState(() {
                            _isLoading = true;
                          });

                          const JsonEncoder encoder = JsonEncoder();

                          final scoutDataProvider =
                              Provider.of<ScoutDataProvider>(
                            context,
                            listen: false,
                          );

                          final robot = Robot(
                            id: '${scoutDataProvider.scoutUser!.id}$_allianceId$_floorPickupId$_finalStatusId$_driverSkillId$_autoTopScored',
                            teamNumber:
                                int.tryParse(_teamNumberController.text) ?? 0,
                            matchNumber:
                                int.tryParse(_matchNumberController.text) ?? 0,
                            allianceId: _allianceId,
                            autoTopScored: _autoTopScored,
                            autoMiddleScored: _autoMiddleScored,
                            autoBottomScored: _autoBottomScored,
                            leftCommunity: _leftCommunity,
                            docked: _docked,
                            engaged: _engaged,
                            teleopTopScored: _teleopTopScored,
                            teleopMiddleScored: _teleopMiddleScored,
                            teleopBottomScored: _teleopBottomScored,
                            teleopLinksScored: _teleopLinksScored,
                            coopBonus: _coopBonus,
                            wasDefended: _wasDefended,
                            floorPickupId: _floorPickupId,
                            dockingTimer: _dockingTimer,
                            finalStatusId: _finalStatusId,
                            allianceRobots: _allianceRobots,
                            driverSkillId: _driverSkillId,
                            speedRating: _speedRating,
                            missedPieces: _missedPieces,
                            died: _died,
                            tippy: _tippy,
                            errorFoul: _errorFoul,
                            mechFail: _mechFail,
                            defense: _defense,
                            comment: _commentController.text,
                            scoutId: scoutDataProvider.scoutUser!.id,
                            scoutName: scoutDataProvider.scoutUser!.name,
                            dateTimeCreated: DateTime.now(),
                          );

                          // Saving robot in-state and locally
                          final robotsProvider = Provider.of<RobotsProvider>(
                            context,
                            listen: false,
                          );

                          if (_isEditing) {
                            await robotsProvider.editRobot(robot, _previousId);
                          } else {
                            await robotsProvider.addRobot(robot);
                          }

                          setState(() {
                            _isLoading = false;
                          });

                          final String jsonRobot =
                              encoder.convert(robot.toMap());

                          if (context.mounted) {
                            Navigator.of(context).popAndPushNamed(
                              QRCodeScreen.routeName,
                              arguments: jsonRobot,
                            );
                          }
                        },
                  borderRadius: BorderRadius.circular(16.0),
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: const Color.fromARGB(255, 255, 0, 0),
                    ),
                    child: _isLoading
                        ? const CupertinoActivityIndicator()
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Send',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
