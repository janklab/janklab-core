classdef PlanarClassDefinition
    
    properties
        fqClassName = '';
        
        planarClassOptions = {};
        planarIdentityFields = {};
        planarFields = {};
        planarNanFields = {};
        planarNoNanFields = {};
        planarNanFlags = {};
        planarNanFlag = [];
        hasPlanarNanFlag = false;
        
        doSetops = false;
        
        isHandle = false;
        usesPlanarClassBase = false;
        userMethodNames = {};
        hasUserSubsref = false;
        hasUserSubsasgn = false;
        hasUserNumArgumentsFromSubscript = false;
        hasUserIsNan = false;
        
        % True if this class has an isnan() method from some source
        isNanable = false;
        
        codeInfo
    end
end