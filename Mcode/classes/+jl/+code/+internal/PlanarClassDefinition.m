classdef PlanarClassDefinition
    
    properties
        fqClassName (1,1) string = string(missing);
        
        planarClassOptions string
        planarIdentityFields string
        planarFields string
        planarNanFields string
        planarNoNanFields string
        planarNanFlags string
        planarNanFlag (1,1) string = string(missing)
        hasPlanarNanFlag (1,1) logical = false;
        planarConditionCodeField (1,1) string = string(missing)
        hasPlanarConditionCode (1,1) logical = false;
        
        doSetops (1,1) logical = false;
        
        isHandle (1,1) logical = false;
        usesPlanarClassBase (1,1) logical = false;
        userMethodNames string
        hasUserSubsref (1,1) logical = false;
        hasUserSubsasgn (1,1) logical = false;
        hasUserNumArgumentsFromSubscript (1,1) logical = false;
        hasUserIsNan (1,1) logical = false;
        
        % True if this class has an isnan() method from some source
        isNanable (1,1) logical = false;
        
        codeInfo
    end
end