CLASS lhc_RAPGeneratorBOLog DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS CalculateLogItemNumber FOR DETERMINE ON SAVE
      IMPORTING keys FOR RAPGeneratorBOLog~CalculateLogItemNumber.

ENDCLASS.

CLASS lhc_RAPGeneratorBOLog IMPLEMENTATION.

  METHOD CalculateLogItemNumber.

  "Ensure idempotence

    " Read all rap bos for the requested log entries
    " If multiple logentries of the same rapbo are requested, the rapbo
    " is returned only once.

    READ ENTITIES OF ZDMO_R_RapGeneratorBO IN LOCAL MODE
      ENTITY RAPGeneratorBOLog by \_RAPGeneratorBO
        FIELDS ( RapNodeUUID )
        WITH CORRESPONDING #( keys )
      RESULT DATA(rapbos).

    DATA max_log_item_number TYPE ZDMO_R_RapGeneratorBOLog-LogItemNumber.
    DATA log_entries_update TYPE TABLE FOR UPDATE ZDMO_R_RapGeneratorBO\\RAPGeneratorBOLog.



    " Process all affected travels. Read respective bookings for one travel
    LOOP AT rapbos INTO DATA(rapbo).
      READ ENTITIES OF ZDMO_R_RapGeneratorBO
        ENTITY RAPGeneratorBO BY \_RAPGeneratorBOLog
          FIELDS ( LogItemNumber )
          WITH VALUE #( ( %tky = rapbo-%tky ) )
        RESULT DATA(log_entries).

      " find max used bookingID in all bookings of this travel
      max_log_item_number = '000000'.

      LOOP AT log_entries INTO DATA(log_entry).
        IF log_entry-LogItemNumber > max_log_item_number.
          max_log_item_number = log_entry-LogItemNumber.
        ENDIF.
      ENDLOOP.

      "Provide a log item number for all log entries of this rap bo that have none.
      LOOP AT log_entries INTO log_entry WHERE LogItemNumber IS INITIAL.
        max_log_item_number += 1.
        APPEND VALUE #( %tky      = log_entry-%tky
                        logitemnumber = max_log_item_number
                      ) TO log_entries_update.

      ENDLOOP.
    ENDLOOP.

    " Provide a log item number for all log entries that have none.
    MODIFY ENTITIES OF ZDMO_R_RapGeneratorBO
      ENTITY RAPGeneratorBOLog
        UPDATE FIELDS ( LogItemNumber )
        WITH log_entries_update.

  ENDMETHOD.

ENDCLASS.
