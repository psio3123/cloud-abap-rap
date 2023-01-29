@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'CDS View forRAPGeneratorBONode'
define view entity ZDMO_R_RapGeneratorBOLog
  as select from zdmo_rapgen_log
  association        to parent ZDMO_R_RapGeneratorBO as _RAPGeneratorBO on $projection.RapboUuid = _RAPGeneratorBO.RapNodeUUID
  {
  key log_uuid as LogUuid,
  rapbo_uuid as RapboUuid,
  log_item_number as LogItemNumber,
  detail_level as DetailLevel,
  severity as Severity,
  text as Text,
  time_stamp as TimeStamp,
  local_last_changed_at as LocalLastChangedAt,
  _RAPGeneratorBO

}
