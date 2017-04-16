#pragma once
//------------------------------------------------------------------------------
/**
    @class Oryol::_priv::glShaderFactory
    @ingroup _priv
    @brief private: GL implementation of shaderFactory
*/
#include "Resource/ResourceState.h"
#include "Gfx/Core/GfxTypes.h"
#include "Gfx/Core/gfxPointers.h"
#include "Gfx/gl/gl_decl.h"
#include "Core/String/StringBuilder.h"

namespace Oryol {
namespace _priv {

class shader;

class glShaderFactory {
public:
    /// destructor
    ~glShaderFactory();
    
    /// setup the factory
    void Setup(const gfxPointers& ptrs);
    /// discard the factory
    void Discard();
    /// return true if the object has been setup
    bool IsValid() const;
    
    /// setup resource
    ResourceState::Code SetupResource(shader& shd);
    /// destroy resource
    void DestroyResource(shader& shd);

private:
    /// compile a GL shader (return 0 if failed)
    GLuint compileShader(ShaderStage::Code stage, const char* sourceString, int sourceLen) const;

    gfxPointers pointers;
    StringBuilder strBuilder;
    bool isValid = false;
};
    
} // namespace _priv
} // namespace Oryol
