export default interface JsonUser {
  id: number;
  username: string;
  email: string;
  password: string;
  avatar: string | null;
  registrationTime: string;
  lastLogin: string | null;
  status: string;
}