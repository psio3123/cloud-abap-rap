@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View forRAPGeneratorBONode'
//@ObjectModel.semanticKey: [ 'EntityName' ]
@Search.searchable: true




define view entity ZDMO_C_RAPGeneratorBOLog
  as projection on ZDMO_R_RapGeneratorBOLog
{
  key LogUuid,
      RapboUuid,
      LogItemNumber,
      DetailLevel,
      Severity,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Text,
      TimeStamp,
      LocalLastChangedAt,
      /* Associations */
      _RAPGeneratorBO : redirected to parent ZDMO_C_RAPGENERATORBO

}
