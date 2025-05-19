
export default class Result<T = null> {

  public success: boolean;

  public data: T | null;

  public message: string;

  constructor(success: boolean, data: T | null = null, message: string = "") {
    this.success = success;
    this.data = data;
    this.message = message;
  }

  public static success<T>(data: T | null = null, message: string = ""): Result<T> {
    return new Result(true, data, message);
  }

  public static fail<T>(data: T | null = null, message: string = ""): Result<T> {
    return new Result(false, data, message);
  }

  public static error<T>(data: T | null = null, err: string | Error, def: string = ""): Result<T> {
    if (err instanceof Error) {
      return Result.fail(data, err.message);
    }
    else if (typeof err === "string") {
      return Result.fail(data, err);
    }
    return new Result(false, data, def);
  }
}