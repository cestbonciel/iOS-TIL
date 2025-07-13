// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"

// Deno 전역 객체 타입 선언 (린터 에러 해결용)
declare global {
  const Deno: {
    env: {
      get(key: string): string | undefined
    }
    serve(handler: (req: Request) => Promise<Response> | Response): void
  }
}

console.log("☕ Coffee Push Notification Service Started!")

interface PushRequest {
  deviceToken: string
  title: string
  body: string
  badge?: number
  sound?: string
  customData?: Record<string, any>
}

interface APNsPayload {
  aps: {
    alert: {
      title: string
      body: string
    }
    badge?: number
    sound?: string
  }
  [key: string]: any
}

Deno.serve(async (req) => {
  // CORS 처리
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      status: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      },
    })
  }

  try {
    const { deviceToken, title, body, badge = 1, sound = "default", customData = {} }: PushRequest = await req.json()

    // 필수 값 검증
    if (!deviceToken || !title || !body) {
      return new Response(
        JSON.stringify({ 
          error: "Missing required fields: deviceToken, title, body" 
        }),
        { 
          status: 400,
          headers: { 
            "Content-Type": "application/json",
            'Access-Control-Allow-Origin': '*'
          } 
        },
      )
    }

    // APNs Payload 구성
    const payload: APNsPayload = {
      aps: {
        alert: {
          title,
          body
        },
        badge,
        sound
      },
      ...customData
    }

    // APNs 환경 설정
    const isProduction = Deno.env.get("ENVIRONMENT") === "production"
    const apnsUrl = isProduction 
      ? "https://api.push.apple.com:443/3/device/"
      : "https://api.sandbox.push.apple.com:443/3/device/"

    // APNs 인증 정보 (환경 변수에서 가져오기)
    const keyId = Deno.env.get("APNS_KEY_ID") || "5MP56VBUBF"
    const teamId = Deno.env.get("APNS_TEAM_ID") || "2P5FNS3JAJ"
    const bundleId = Deno.env.get("APNS_BUNDLE_ID") || "com.seohyunKim.iOS.CoffeePushWidget2025"
    const privateKey = Deno.env.get("APNS_PRIVATE_KEY") // P8 파일 내용

    if (!privateKey) {
      return new Response(
        JSON.stringify({ 
          error: "APNs private key not configured. Please set APNS_PRIVATE_KEY environment variable." 
        }),
        { 
          status: 500,
          headers: { 
            "Content-Type": "application/json",
            'Access-Control-Allow-Origin': '*'
          } 
        },
      )
    }

    // JWT 토큰 생성 (APNs 인증용)
    const jwt = await generateAPNsJWT(keyId, teamId, privateKey)

    // APNs로 푸시 알림 전송
    const response = await fetch(`${apnsUrl}${deviceToken}`, {
      method: 'POST',
      headers: {
        'authorization': `bearer ${jwt}`,
        'apns-id': crypto.randomUUID(),
        'apns-push-type': 'alert',
        'apns-priority': '10',
        'apns-topic': bundleId,
        'content-type': 'application/json',
      },
      body: JSON.stringify(payload),
    })

    console.log(`📱 APNs Response Status: ${response.status}`)

    if (response.ok) {
      return new Response(
        JSON.stringify({ 
          success: true,
          message: "Push notification sent successfully",
          apnsId: response.headers.get('apns-id'),
          deviceToken: deviceToken.substring(0, 10) + "..." // 보안을 위해 일부만 표시
        }),
        { 
          status: 200,
          headers: { 
            "Content-Type": "application/json",
            'Access-Control-Allow-Origin': '*'
          } 
        },
      )
    } else {
      const errorText = await response.text()
      console.error(`❌ APNs Error: ${response.status} - ${errorText}`)
      
      return new Response(
        JSON.stringify({ 
          success: false,
          error: `APNs Error: ${response.status}`,
          details: errorText
        }),
        { 
          status: response.status,
          headers: { 
            "Content-Type": "application/json",
            'Access-Control-Allow-Origin': '*'
          } 
        },
      )
    }

  } catch (error) {
    console.error("💥 Edge Function Error:", error)
    return new Response(
      JSON.stringify({ 
        success: false,
        error: "Internal server error",
        details: error.message
      }),
      { 
        status: 500,
        headers: { 
          "Content-Type": "application/json",
          'Access-Control-Allow-Origin': '*'
        } 
      },
    )
  }
})

// JWT 토큰 생성 함수 (APNs 인증용)
async function generateAPNsJWT(keyId: string, teamId: string, privateKey: string): Promise<string> {
  try {
    console.log("🔐 Generating JWT with real ES256 signature...")
    
    // JWT 헤더
    const header = {
      alg: "ES256",
      kid: keyId
    }

    // JWT 페이로드  
    const payload = {
      iss: teamId,
      iat: Math.floor(Date.now() / 1000)
    }

    console.log(`📋 Header: ${JSON.stringify(header)}`)
    console.log(`📋 Payload: ${JSON.stringify(payload)}`)

    // Base64URL 인코딩 함수 (브라우저 내장 API 사용)
    const base64UrlEncode = (obj: any): string => {
      const jsonString = JSON.stringify(obj)
      const encoded = btoa(jsonString)
      return encoded.replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '')
    }

    const encodedHeader = base64UrlEncode(header)
    const encodedPayload = base64UrlEncode(payload)
    const signingInput = `${encodedHeader}.${encodedPayload}`

    console.log(`🔗 Signing input: ${signingInput}`)

    // P8 키 클리닝
    const cleanKey = privateKey
      .replace(/-----BEGIN PRIVATE KEY-----/, '')
      .replace(/-----END PRIVATE KEY-----/, '')
      .replace(/\s/g, '')

    console.log(`🔑 Cleaned key length: ${cleanKey.length}`)

    // DER 형식으로 디코딩
    const binaryKey = new Uint8Array(
      atob(cleanKey).split('').map(char => char.charCodeAt(0))
    )
    
    console.log(`🔢 Binary key length: ${binaryKey.length}`)

    // ECDSA P-256 키 임포트
    const cryptoKey = await crypto.subtle.importKey(
      'pkcs8',
      binaryKey,
      {
        name: 'ECDSA',
        namedCurve: 'P-256'
      },
      false,
      ['sign']
    )

    console.log("✅ Key imported successfully")

    // 서명 생성
    const signature = await crypto.subtle.sign(
      {
        name: 'ECDSA',
        hash: 'SHA-256'
      },
      cryptoKey,
      new TextEncoder().encode(signingInput)
    )

    console.log(`✍️ Signature generated: ${signature.byteLength} bytes`)

    // 서명을 Base64URL로 인코딩
    const signatureArray = new Uint8Array(signature)
    const signatureBase64 = btoa(String.fromCharCode(...signatureArray))
    const signatureBase64Url = signatureBase64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, '')

    const finalJWT = `${signingInput}.${signatureBase64Url}`
    console.log(`🎫 Final JWT length: ${finalJWT.length}`)
    
    return finalJWT
    
  } catch (error) {
    console.error('🚨 JWT generation error:', error)
    console.error('Stack trace:', error.stack)
    
    // 실패 시 더미 토큰 (개발용)
    console.log("⚠️ Falling back to dummy token")
    return "dummy-jwt-token-for-testing"
  }
}

/* 사용 예시:

curl -i --location --request POST 'http://127.0.0.1:54321/functions/v1/send-push' \
  --header 'Authorization: Bearer [YOUR_SUPABASE_ANON_KEY]' \
  --header 'Content-Type: application/json' \
  --data '{
    "deviceToken": "your-device-token-here",
    "title": "☕ Coffee Time!",
    "body": "Your perfect espresso is ready",
    "badge": 1,
    "customData": {
      "coffeeType": "espresso",
      "timestamp": "2024-06-24T10:00:00Z"
    }
  }'

*/
