import { Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import * as bcrypt from 'bcrypt';
import { UsersService } from '../users/users.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { User } from '../users/entities/user.entity';

export interface JwtPayload {
  sub: string;
  email: string;
}

export interface AuthResponse {
  user: Partial<User>;
  accessToken: string;
  refreshToken: string;
}

@Injectable()
export class AuthService {
  constructor(
    private usersService: UsersService,
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  /**
   * Register a new user
   */
  async register(registerDto: RegisterDto): Promise<AuthResponse> {
    const existingUser = await this.usersService.findByEmail(registerDto.email);
    
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    const hashedPassword = await bcrypt.hash(registerDto.password, 10);
    
    const user = await this.usersService.create({
      ...registerDto,
      password: hashedPassword,
    });

    return this.generateTokens(user);
  }

  /**
   * Login user with email and password
   */
  async login(loginDto: LoginDto): Promise<AuthResponse> {
    const user = await this.usersService.findByEmail(loginDto.email);
    
    if (!user || !user.password) {
      throw new UnauthorizedException('Invalid credentials');
    }

    const isPasswordValid = await bcrypt.compare(loginDto.password, user.password);
    
    if (!isPasswordValid) {
      throw new UnauthorizedException('Invalid credentials');
    }

    return this.generateTokens(user);
  }

  /**
   * Logout user (invalidate refresh token - for future Redis implementation)
   */
  async logout(userId: string): Promise<{ message: string }> {
    // In a production app, you would invalidate the refresh token in Redis
    // For now, we just return success
    return { message: 'Successfully logged out' };
  }

  /**
   * Refresh access token using refresh token
   */
  async refreshToken(token: string): Promise<{ accessToken: string }> {
    try {
      const payload = this.jwtService.verify(token, {
        secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      });

      const user = await this.usersService.findById(payload.sub);
      
      if (!user) {
        throw new UnauthorizedException('Invalid refresh token');
      }

      const accessToken = this.jwtService.sign(
        { sub: user.id, email: user.email },
        {
          secret: this.configService.get<string>('JWT_SECRET'),
          expiresIn: this.configService.get<string>('JWT_EXPIRES_IN', '7d'),
        },
      );

      return { accessToken };
    } catch {
      throw new UnauthorizedException('Invalid or expired refresh token');
    }
  }

  /**
   * Forgot password - send reset email (mock implementation)
   */
  async forgotPassword(forgotPasswordDto: ForgotPasswordDto): Promise<{ message: string }> {
    const user = await this.usersService.findByEmail(forgotPasswordDto.email);
    
    // Always return success to prevent email enumeration attacks
    if (!user) {
      return { message: 'If the email exists, a reset link has been sent' };
    }

    // In production, generate a reset token and send email
    // For now, we just return success
    return { message: 'If the email exists, a reset link has been sent' };
  }

  /**
   * Reset password using reset token (mock implementation)
   */
  async resetPassword(resetPasswordDto: ResetPasswordDto): Promise<{ message: string }> {
    // In production, verify the reset token from the URL
    // For now, we just hash the new password
    
    const hashedPassword = await bcrypt.hash(resetPasswordDto.newPassword, 10);
    
    // In production, you would:
    // 1. Verify the reset token
    // 2. Find user by token
    // 3. Update password
    // 4. Invalidate all refresh tokens for this user
    
    return { message: 'Password has been reset successfully' };
  }

  /**
   * Get current user profile
   */
  async getProfile(userId: string): Promise<Partial<User>> {
    const user = await this.usersService.findById(userId);
    
    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    const { password, ...result } = user;
    return result;
  }

  /**
   * Update user password (when logged in)
   */
  async changePassword(
    userId: string,
    currentPassword: string,
    newPassword: string,
  ): Promise<{ message: string }> {
    const user = await this.usersService.findById(userId);
    
    if (!user || !user.password) {
      throw new UnauthorizedException('User not found');
    }

    const isPasswordValid = await bcrypt.compare(currentPassword, user.password);
    
    if (!isPasswordValid) {
      throw new UnauthorizedException('Current password is incorrect');
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    await this.usersService.updatePassword(userId, hashedPassword);

    return { message: 'Password changed successfully' };
  }

  /**
   * Generate access and refresh tokens
   */
  private generateTokens(user: User): AuthResponse {
    const payload: JwtPayload = { sub: user.id, email: user.email };

    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, {
      secret: this.configService.get<string>('JWT_REFRESH_SECRET'),
      expiresIn: this.configService.get<string>('JWT_REFRESH_EXPIRES_IN', '30d'),
    });

    const { password, ...userWithoutPassword } = user;

    return {
      user: userWithoutPassword,
      accessToken,
      refreshToken,
    };
  }
}
